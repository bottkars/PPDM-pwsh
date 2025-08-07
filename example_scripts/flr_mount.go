package main

import (
        "flag"
        "fmt"
        "os"
        "os/exec"
        "path/filepath"
        "strings"
        "time"

        "github.com/gdamore/tcell/v2"
        "github.com/rivo/tview"
)

var action string

func init() {
        flag.StringVar(&action, "action", "", "Action for -k parameter: mount or unmount (required)")
        flag.Parse()
        if action != "mount" && action != "unmount" {
                fmt.Println("Usage: flr_mount -action mount|unmount")
                os.Exit(1)
        }
}

func main() {
        cmd := exec.Command("ddfsadmin", "backup", "query", "-remote", "-local", "-v=/home")
        output, err := cmd.Output()
        if err != nil {
                fmt.Println("Error running ddfsadmin:", err)
                return
        }

        lines := strings.Split(string(output), "\n")

        var headers []string
        var data [][]string
        found := false
        for _, line := range lines {
                if strings.HasPrefix(line, "SSID") {
                        headers = parseHeaders(line)
                        found = true
                        continue
                }
                if found && strings.TrimSpace(line) != "" {
                        data = append(data, parseDataLine(line))
                }
        }

        app := tview.NewApplication()
        table := tview.NewTable().SetSelectable(true, false)

        for i, h := range headers {
                table.SetCell(0, i,
                        tview.NewTableCell(h).
                                SetTextColor(tcell.ColorYellow).
                                SetSelectable(false).
                                SetAlign(tview.AlignCenter))
        }

        for row, record := range data {
                for col, val := range record {
                        table.SetCell(row+1, col,
                                tview.NewTableCell(val).
                                        SetTextColor(tcell.ColorWhite).
                                        SetAlign(tview.AlignLeft))
                }
        }

        table.SetSelectedFunc(func(row, column int) {
                if row == 0 {
                        return
                }
                selected := data[row-1]
                env := map[string]string{}
                for i, h := range headers {
                        env[h] = selected[i]
                }

                promptForMissingInputs(app, env, func() {
                        runDDFSrc(app, env)
                })
        })

        if err := app.SetRoot(table, true).Run(); err != nil {
                panic(err)
        }
}

func parseHeaders(line string) []string {
        parts := strings.Fields(line)
        var headers []string
        for i := 0; i < len(parts); i++ {
                switch parts[i] {
                case "Storage":
                        if i+1 < len(parts) && parts[i+1] == "Unit" {
                                headers = append(headers, "DD_STORAGE_UNIT")
                                i++
                        }
                case "Size":
                        if i+1 < len(parts) && parts[i+1] == "(Bytes)" {
                                headers = append(headers, "SIZE_BYTES")
                                i++
                        }
                case "Asset":
                        if i+1 < len(parts) && parts[i+1] == "Name" {
                                headers = append(headers, "ASSET_NAME")
                                i++
                        }
                case "Backup":
                        if i+1 < len(parts) && parts[i+1] == "Time" {
                                headers = append([]string{"BACKUP_TIME"}, headers...)
                                i++
                        }
                default:
                        headers = append(headers, strings.ToUpper(parts[i]))
                }
        }
        return headers
}

func parseDataLine(line string) []string {
        parts := strings.Fields(line)
        if len(parts) < 8 {
                return parts
        }
        return append([]string{strings.Join(parts[7:], " ")}, parts[:7]...)
}

func promptForMissingInputs(app *tview.Application, env map[string]string, onDone func()) {
        onDone()
}

func runDDFSrc(app *tview.Application, env map[string]string) {
        cleanOldLogs(7)

        // Get system FQDN
        fqdnBytes, fqdnErr := exec.Command("hostname", "-f").Output()
        fqdn := "unknown"
        if fqdnErr == nil {
                fqdn = strings.TrimSpace(string(fqdnBytes))
        }

        args := []string{
                "-h", "DFA_SI_DEVICE_PATH=" + env["DD_STORAGE_UNIT"],
                "-h", "DFA_SI_DD_HOST=" + env["DD_IP"],
                "-h", "DFA_SI_DD_USER=" + env["DD_USERNAME"],
                "-S", env["SSID"],
                "-k", action,
                "-c", fqdn,
        }

        cmd := exec.Command("ddfsrc", args...)
        output, err := cmd.CombinedOutput()

        logFileName := fmt.Sprintf("ddfsrc-%s.log", time.Now().Format("2006-01-02"))
        f, ferr := os.OpenFile(logFileName, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
        if ferr == nil {
                defer f.Close()
                logEntry := fmt.Sprintf(
                        "[%s]\nCommand: %s\nOutput:\n%s\n\n",
                        time.Now().Format("2006-01-02 15:04:05"),
                        strings.Join(cmd.Args, " "),
                        string(output),
                )
                f.WriteString(logEntry)
        }

        modal := tview.NewModal().
                SetText(fmt.Sprintf("Command executed:\n\n%s\n\nOutput:\n%s", strings.Join(cmd.Args, " "), string(output))).
                AddButtons([]string{"OK"}).
                SetDoneFunc(func(buttonIndex int, buttonLabel string) {
                        app.Stop()
        })

        if err != nil {
                modal.SetText(fmt.Sprintf("Error running command:\n\n%s\n\nOutput:\n%s", err.Error(), string(output)))
        }

        app.SetRoot(modal, true).SetFocus(modal)
}

func cleanOldLogs(retentionDays int) {
        files, err := filepath.Glob("ddfsrc-*.log")
        if err != nil {
                return
        }
        cutoff := time.Now().AddDate(0, 0, -retentionDays)
        for _, file := range files {
                info, err := os.Stat(file)
                if err == nil && info.ModTime().Before(cutoff) {
                        _ = os.Remove(file)
                }
        }
}
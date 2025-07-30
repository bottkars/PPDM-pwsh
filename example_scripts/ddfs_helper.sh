export_ddfs_vars_from_lockbox() {
    # Run the command and capture the first two lines
    local output
    output=$(ddfsadmin lockbox -query | head -n 2)

    # Extract lines
    local keys_line
    local values_line
    keys_line=$(echo "$output" | sed -n '1p')
    values_line=$(echo "$output" | sed -n '2p')

    # Replace multiple spaces with a delimiter (e.g., tab), and single spaces in keys with underscores
    local keys=($(echo "$keys_line" | sed -E 's/ {2,}/\t/g' | sed -E 's/ /_/g' | tr '\t' '\n'))
    local values=($(echo "$values_line" | sed -E 's/ {2,}/\t/g' | tr '\t' '\n'))

    # Export variables
    local count=${#keys[@]}
    for ((i=0; i<$count; i++)); do
        local key="${keys[$i]}"
        local value="${values[$i]}"
        local var_name=$(echo "$key" | tr '[:lower:]' '[:upper:]')
        export "$var_name=$value"
        echo "Exported: $var_name=$value"
    done
}

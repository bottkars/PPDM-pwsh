#!/bin/bash

KEYVAULT_NAME="vault0002kb"
NUM_SECRETS=34
NUM_KEYS=92
NUM_CERTS=9200

# Create random secrets
for i in $(seq 1 $NUM_SECRETS); do
  SECRET_NAME="random-secret-$i"
  SECRET_VALUE=$(openssl rand -hex 16)
  echo "Creating secret: $SECRET_NAME"
  az keyvault secret set --vault-name "$KEYVAULT_NAME" --name "$SECRET_NAME" --value "$SECRET_VALUE"
done

# Create RSA keys
for i in $(seq 1 $NUM_KEYS); do
  KEY_NAME="random-key-$i"
  echo "Creating RSA key: $KEY_NAME"
  az keyvault key create --vault-name "$KEYVAULT_NAME" --name "$KEY_NAME" --kty RSA --size 2048
done

# Create self-signed certificates
for i in $(seq 1 $NUM_CERTS); do
  CERT_NAME="random-cert-$i"
  echo "Creating self-signed certificate: $CERT_NAME"
  az keyvault certificate create \
    --vault-name "$KEYVAULT_NAME" \
    --name "$CERT_NAME" \
    --policy "$(az keyvault certificate get-default-policy)"
done

echo "✅ Vault '$KEYVAULT_NAME' populated with $NUM_SECRETS secrets, $NUM_KEYS keys, and $NUM_CERTS certificates."

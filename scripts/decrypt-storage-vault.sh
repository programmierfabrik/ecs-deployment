#!/bin/bash
set -e

usage(){
    cat << EOF
Usage:  $0

The following gpg files must exist: ./decrypt/vault_encrypt, ./decrypt/vault_sign
The storage_vault must exist: ./decrypt/storage_vault
EOF
    exit 1
}

# Check if keys exists
if [[ -f "./decrypt/vault_encrypt" && -f "./decrypt/vault_sign" ]]; then
    echo "vault_encrypt and vault_sign exist..."
else
    usage
fi

# Check if storage_vault exists
if [[ -d "./decrypt/storage-vault" ]]; then
    echo "storage_vault exist..."
else
    usage
fi

# Create .gpg folder and import the keys
mkdir ./decrypt/.gpg
gpg --homedir ./decrypt/.gpg --import ./decrypt/{vault_encrypt,vault_sign}

# Decrypt all files and save them as .tmp
find ./decrypt/storage_vault -type f -exec gpg --homedir ./decrypt/.gpg --yes --always-trust --output '{}.tmp' --decrypt '{}' \;

# Now move (and override) the encrypted files with the decryptes files -> "xxx.tmp" to "xxx"
find ./decrypt/storage_vault -name "*.tmp" -type f -exec sh -c 'tmp_path="{}"; new_path="${tmp_path%%.tmp}"; mv -f "{}" "$new_path"' \;

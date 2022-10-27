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

if [[ ! -d ./decrypt/.gnupg ]]; then
    # Create .gpg folder and import the keys
    mkdir ./decrypt/.gnupg
    gpg --homedir ./decrypt/.gnupg --import ./decrypt/{vault_encrypt,vault_sign}
    find ./decrypt/.gnupg -type f -exec chmod 600 {} \;
    find ./decrypt/.gnupg -type d -exec chmod 700 {} \;
fi


# Decrypt all files and save them as .tmp
find ./decrypt/storage-vault -type f -exec gpg --homedir ./decrypt/.gnupg --yes --always-trust --output '{}.tmp' --decrypt '{}' \;

# Now move (and override) the encrypted files with the decryptes files -> "xxx.tmp" to "xxx"
find ./decrypt/storage-vault -name "*.tmp" -type f -exec sh -c 'tmp_path="{}"; new_path="${tmp_path%%.tmp}"; mv -f "{}" "$new_path"' \;

#!/bin/bash
set -e

usage(){
    cat << EOF
Usage:  $0

The following gpg files must exist: ./decrypt/vault_encrypt, ./decrypt/vault_sign
The storage-vault must exist: ./decrypt/storage-vault
EOF
    exit 1
}

# Check if keys exists
if [[ -f "./decrypt/vault_encrypt" && -f "./decrypt/vault_sign" ]]; then
    echo "vault_encrypt and vault_sign exist..."
else
    usage
fi

# Check if storage-vault exists
if [[ -d "./decrypt/storage-vault" ]]; then
    echo "storage-vault exist..."
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

echo "File count before decryption: $(find ./decrypt/storage-vault -type f | wc -l)" >> ./decrypt/log
# Decrypt all files and save them as .tmp. After the decryption, override the encrypted file with the decrypted one
find ./decrypt/storage-vault -type f -exec gpg --homedir ./decrypt/.gnupg --yes --quiet --always-trust --output '{}.tmp' --decrypt '{}' \; -exec sh -c 'tmp_path="{}.tmp"; new_path="${tmp_path%%.tmp}"; mv -f "{}.tmp" "$new_path"' \;
echo "File count after decryption: $(find ./decrypt/storage-vault -type f | wc -l)" >> ./decrypt/log

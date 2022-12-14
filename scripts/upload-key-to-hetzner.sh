#!/bin/bash

usage(){
    cat << EOF
Usage: $0 u123456 password

Upload your ssh private key to your hetzner storagebox
EOF
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

me=`basename "$0"`

public_key=$(cat ./data/.ssh/id_rsa.pub)
tmpfile=$(mktemp /tmp/${me}.XXXXXXXXXX)
echo "$public_key" > $tmpfile

sftp $1@$1.your-storagebox.de <<EOF
mkdir .ssh
chmod 700 .ssh
put ${tmpfile} .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
EOF

ssh-keyscan $1.your-storagebox.de >> ./data/.ssh/known_hosts

rm $tmpfile

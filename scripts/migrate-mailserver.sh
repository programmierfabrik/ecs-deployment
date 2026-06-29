#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

OPENDKIM_KEYS_DIR="data/mailserver/config/opendkim/keys"
RSPAMD_DKIM_DIR="data/mailserver/config/rspamd/dkim"

mkdir -p "$RSPAMD_DKIM_DIR"

for key in "$OPENDKIM_KEYS_DIR"/*/mail.private; do
    domain="$(basename "$(dirname "$key")")"
    dest="${RSPAMD_DKIM_DIR}/rsa-2048-mail-${domain}.private.txt"
    cp "$key" "$dest"
    echo "Copied: $key → $dest"
done

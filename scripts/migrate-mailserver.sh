#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

OPENDKIM_KEYS_DIR="data/mailserver/config/opendkim/keys"
RSPAMD_DKIM_DIR="data/mailserver/config/rspamd/dkim"
DKIM_SIGNING_CONF="data/mailserver/config/rspamd/override.d/dkim_signing.conf"

mkdir -p "$RSPAMD_DKIM_DIR"

for key in "$OPENDKIM_KEYS_DIR"/*/mail.private; do
    domain="$(basename "$(dirname "$key")")"
    dest="${RSPAMD_DKIM_DIR}/rsa-2048-mail-${domain}.private.txt"
    cp "$key" "$dest"
    echo "Copied: $key → $dest"
done

# ECS relays mail to the mailserver unauthenticated over the internal docker
# network (SMTP_URL=smtp://mailserver:25), which rspamd classifies as "local".
# The generated config only signs authenticated senders by default, so ECS's
# own mail is silently sent out unsigned unless local senders are signed too.
if [ -f "$DKIM_SIGNING_CONF" ]; then
    sed -i 's/sign_local = false;/sign_local = true;/' "$DKIM_SIGNING_CONF"
    echo "Enabled sign_local in $DKIM_SIGNING_CONF"
fi

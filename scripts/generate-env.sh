#!/bin/bash

usage(){
    cat << EOF
Usage: $0 domain.name

Generate a .env file for a production deployment.
EOF
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

if test -f "./.env"; then
    echo ".env already exists..."
    exit 1
fi

HOST=$1
ECS_SECRET_KEY=$(openssl rand -base64 39)
ECS_REGISTRATION_SECRET=$(openssl rand -base64 39)
ECS_PASSWORD_RESET_SECRET=$(openssl rand -base64 39)
BACKUP_PHASSPHRASE=$(openssl rand -base64 39)

cat << EOF > ./.env
# ===== Basic Variables
TAG=
HOST=$HOST
ECS_COMMISSION_UUID=ecececececececececececececececec
ECS_REQUIRE_CLIENT_CERTS=true
ECS_USERSWITCHER_ENABLED=false
ECS_EMAIL_ENABLED=true
ECS_DISABLE_REGISTER=false
ECS_VOTE_RECEIVERS=BASG.EKVoten@ages.at
ECS_SENTRY_DSN=
ECS_LOG_LEVEL=WARNING
BACKUP_URI=file:///local-backup
ACME_EMAIL=ecs.support@programmierfabrik.at
EXPORTER_AUTH_USER=
EXPORTER_PROMETHEUS_IP=
CROWDSEC_BOUNCER_KEY=
# ===== Generated Variables
ECS_SECRET_KEY=$ECS_SECRET_KEY
ECS_REGISTRATION_SECRET=$ECS_REGISTRATION_SECRET
ECS_PASSWORD_RESET_SECRET=$ECS_PASSWORD_RESET_SECRET
BACKUP_PASSPHRASE=$BACKUP_PHASSPHRASE
EOF

mkdir -p data/ecs volatile/ecs
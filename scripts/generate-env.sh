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

HOST=$1
ECS_SECRET_KEY=$(openssl rand -base64 39)
ECS_REGISTRATION_SECRET=$(openssl rand -base64 39)
ECS_PASSWORD_RESET_SECRET=$(openssl rand -base64 39)

cat << EOF > ./.env
# ===== Basic Variables
HOST=$HOST
ECS_COMMISSION_UUID=ecececececececececececececececec
ECS_USERSWITCHER_ENABLED=false
BACKUP_URI=file:///local-backup
ACME_EMAIL=ecs.support@programmierfabrik.at
# ===== Hardcoded Production Variables
ECS_PROD=true
ECS_DOMAIN=\${HOST}
DATABASE_URL=postgres://ecs:ecs@database:5432/ecs
REDIS_URL=redis://redis:6379/0
MEMCACHED_URL=memcached:11211
SMTP_URL=smtp://mailserver:25
# ===== Generated Variables
ECS_SECRET_KEY=$ECS_SECRET_KEY
ECS_REGISTRATION_SECRET=$ECS_REGISTRATION_SECRET
ECS_PASSWORD_RESET_SECRET=$ECS_PASSWORD_RESET_SECRET
EOF

mkdir -p data/ecs volatile/ecs
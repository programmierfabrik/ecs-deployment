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

generate_gpg() {
    echo "$(docker run -e name=$1 -t --rm ubuntu:xenial \
    bash -c 'gpg --quiet --no-default-keyring --enable-special-filenames --batch --yes --armor --gen-key 2>/dev/null << EOF
Key-Type: 1
Key-Length: 2048
Expire-Date: 0
Name-Real: $name
%secring -&1
%pubring -&2
%commit
EOF')"
}

HOST=$1
ECS_SECRET_KEY=$(openssl rand -base64 39)
ECS_REGISTRATION_SECRET=$(openssl rand -base64 39)
ECS_PASSWORD_RESET_SECRET=$(openssl rand -base64 39)
ECS_VAULT_ENCRYPT=$(generate_gpg 'ecs_mediaserver')
ECS_VAULT_SIGN=$(generate_gpg 'ecs_authority')

cat << EOF > ./.env
# ===== Basic Variables
HOST=$HOST
ECS_COMMISSION_UUID=ecececececececececececececececec
ECS_USERSWITCHER_ENABLED=false
# ===== Hardcoded Production Variables
ECS_PROD=true
ECS_DOMAIN=\${HOST}
DATABASE_URL=postgres://ecs:ecs@database:5432/ecs
REDIS_URL=redis://redis:6379/0
MEMCACHED_URL=memcached://memcached:11211
SMTP_URL=smtp://mailserver:25
# ===== Generated Variables
ECS_SECRET_KEY=$ECS_SECRET_KEY
ECS_REGISTRATION_SECRET=$ECS_REGISTRATION_SECRET
ECS_PASSWORD_RESET_SECRET=$ECS_PASSWORD_RESET_SECRET
ECS_VAULT_ENCRYPT="$ECS_VAULT_ENCRYPT"
ECS_VAULT_SIGN="$ECS_VAULT_SIGN"
EOF

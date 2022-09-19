#!/bin/bash

usage(){
    cat << EOF
Usage: $0 true|false true|false

First argument:  whether to pull new images or not
Second argument: whether to update system packages or not

A script for github actions to restart / update the deployment.
EOF
    exit 1
}

if [[ $# -ne 2 ]]; then
    usage
fi

UPDATE_IMAGES=$1
UPDATE_APT=$2

# Absolute path to this script
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Navigate to the root of this project
cd "$SCRIPT_PATH/.."

docker compose down

if [[ $UPDATE_IMAGES == 'true' ]]; then
    echo "Updating images..."
    docker compose pull
fi

if [[ $UPDATE_APT == 'true' ]]; then
    echo "Updating packages..."
    sudo apt-get update -y && sudo apt-get upgrade -yy
fi

docker compose up -d

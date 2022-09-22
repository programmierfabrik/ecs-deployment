#!/bin/bash

usage(){
    cat << EOF
Usage: $0 [option]

Options:
    docker:   will update docker images
    apt:      will update apt packages
    all:      all of the above

A script for github actions to restart / update the deployment.
EOF
    exit 1
}

for i in "$@"; do
    case $i in
    docker)
        UPDATE_IMAGES=true
        ;;
    apt)
        UPDATE_APT=true
        ;;
    all)
        UPDATE_IMAGES=true
        UPDATE_APT=true
        ;;
    *)
        echo "Unknown option \"$i\""
        usage
        ;;
    esac
done

# Absolute path to this script
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Navigate to the root of this project
cd "$SCRIPT_PATH/.."

echo "Stopping docker container..."
docker compose down > /dev/null 2>&1
echo "Docker container down..."

if [[ $UPDATE_IMAGES == 'true' ]]; then
    echo "Updating images..."
    docker compose pull > /dev/null 2>&1
    echo "Finished updating images..."
fi

if [[ $UPDATE_APT == 'true' ]]; then
    echo "Updating packages..."
    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get upgrade -yy > /dev/null 2>&1
    echo "Updated packages..."
fi

echo "Starting docker container..."
docker compose up -d > /dev/null 2>&1
echo "Docker container up..."
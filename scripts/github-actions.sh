#!/bin/bash

usage(){
    cat << EOF
Usage: $0 [option]

Options:
    --docker:   will update docker images
    --apt:      will update apt packages
    --all:      all of the above

A script for github actions to restart / update the deployment.
EOF
    exit 1
}

IFS=' ' read -ra OPTIONS <<< "$SSH_ORIGINAL_COMMAND"
for i in "${OPTIONS[@]}"; do
    echo $i
    case $i in
    --docker)
        UPDATE_IMAGES=true
        ;;
    --apt)
        UPDATE_APT=true
        ;;
    --all)
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

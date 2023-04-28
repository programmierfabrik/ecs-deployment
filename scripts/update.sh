#!/bin/bash

usage() {
    cat << EOF
Usage: $0 [options]

Options:
    hide: Hide the output of all commands

Update docker images, packages and reboot.
EOF
    exit 1
}

for i in "$@"; do
    case $i in
    hide)
        HIDE_OUTPUT=true
        ;;
    *)
        echo "Unknown option \"$i\""
        usage
        ;;
    esac
done

run_command() {
    if [[ $HIDE_OUTPUT == "true" ]]
    then $@
    else $@ 2>&1 > /dev/null
    fi
}

# Absolute path to this script
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# Navigate to the root of this project
cd "$SCRIPT_PATH/.."

run_command "docker compose down"
echo -e "Docker container down...\n"

run_command "docker compose pull"
echo -e "Finished updating images...\n"

echo "Updating packages..."
run_command "sudo apt-get update -y"
run_command "sudo apt-get upgrade -yy"
echo -e "Updated packages...\n"

echo "Rebooting..."
reboot

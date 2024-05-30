#!/usr/bin/env bash

# update_hosts
# A script to update your system's hosts file from the curated list at
# https://github.com/StevenBlack/hosts
#

# strict mode
set -euo pipefail
IFS=$'\n\t'

readonly HOSTS_FILE="/etc/hosts"

# logging
log() {
    logger --tag update_hosts --priority cron.$1 "$2"
}

error() {
    log error "$1"
}

notice() {
    log notice "$1"
}

# grab latest release info
set +e
if ! release_info=$(curl --no-progress-meter --location \
    --header "Accept: application/vnd.github+json" \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/StevenBlack/hosts/releases/latest)
then
    error "Failed to collect release information"
    exit 1
fi

if ! published_at=$(echo "$release_info" | jq --raw-output ".published_at"); then
    error "Failed to parse release information"
    exit 1
fi
set -e

published_at=$(date --date="$published_at" "+%s")
modified_at=$(stat --format="%Y" $HOSTS_FILE)

if ((modified_at > published_at)); then
    notice "Update not required"
    exit 0
fi

# update hosts
temp_update=$(mktemp)
declare -ar update_urls=(
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    "http://sbc.io/hosts/hosts"
)

download_success=false
for url in "${update_urls[@]}"; do
    if wget --no-verbose --output-document=$temp_update $url; then
        download_success=true
        break
    fi
done

if ! $download_success; then
    error "Failed to download hosts file update"
    exit 1
fi

hostname=$(hostname)
sed -i "1 i 127.0.1.1 $hostname\n127.0.0.53 $hostname\n" $temp_update

# backup previous hosts
temp_backup=$(mktemp)
cp "$HOSTS_FILE" "$temp_backup"

# move temporary file to hosts
sudo mv "$temp_update" $HOSTS_FILE
working_dir="$(dirname "${BASH_SOURCE[0]}")"
mv --force "$temp_backup" "$working_dir/hosts.backup"

# restart network
notice "Restarting network..."
sudo service NetworkManager restart

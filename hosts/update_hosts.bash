#!/bin/bash

#
# TODO:
#   - add options for quiet operation, specify logfile location
#   - add option to restore default hosts file or backup?
#

readonly HOSTS_FILE="/etc/hosts"

log() {
    echo "$1"
}

# strict mode
set -euo pipefail
IFS=$'\n\t'

# grab latest release info
set +e
release_info=$(curl --no-progress-meter --location \
    --header "Accept: application/vnd.github+json" \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/StevenBlack/hosts/releases/latest)
if (($? != 0)); then
    log "Error while collecting release information"
    exit 1
fi

published_at=$(echo $release_info | jq --raw-output ".published_at")
if (($? != 0)); then
    log "Error while parsing release information"
    exit 1
fi
set -e

published_at=$(date --date="$published_at" "+%s")
modified_at=$(stat --format="%Y" $HOSTS_FILE)

if ((modified_at > published_at)); then
    log "Update not required"
    exit 0
fi
log "Update available"

# update hosts
temp_update=$(mktemp)
declare -ar update_urls=(
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    "http://sbc.io/hosts/hosts"
)

log "Downloading file..."
download_success=false
for url in ${update_urls[@]}; do
    if wget --no-verbose --output-document=$temp_update $url; then
        download_success=true
        break
    fi
done

if $download_success; then
    log "Download complete"
else
    log "An error occurred while downloading updated hosts file!"
    exit 1
fi

hostname=$(hostname)
sed -i "1 i 127.0.1.1 $hostname\n127.0.0.53 $hostname\n" $temp_update

# backup previous hosts
log "Backing up previous hosts file"
temp_backup=$(mktemp)
cp "$HOSTS_FILE" "$temp_backup"

# move temporary file to hosts
sudo mv $temp_update $HOSTS_FILE
working_dir="$(dirname ${BASH_SOURCE})"
mv "$temp_backup" "$working_dir/hosts.backup"

# restart network
log "Restarting network..."
sudo service network-manager restart

log "Update complete!"

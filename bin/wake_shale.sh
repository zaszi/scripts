#!/bin/env bash

# wake_shale.sh
#
# Author: Zaszi - admin@zaszi.net
#
# Wake-On-LAN shale, relayed through the bastion host galena.
#
# Requirements:
# - SSH access to the network bastion.
# - The wol (Wake-On_LAN) package must be installed on the bastion.
#
# Usage: ./wake_shale.sh

# DEBUG
# set -o xtrace

set -o nounset
set -o pipefail
set -o errexit

main() {
    declare -r bastion="galena"
    declare -r target="24:4b:fe:e1:b7:e0"

    /usr/bin/ssh $bastion "/usr/bin/wol --port=9 $target"
}

main "$@"

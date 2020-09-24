#!/bin/env bash

# wake_crimson.sh
#
# Author: Zaszi - admin@zaszi.net
#
# Wake-On-LAN crimson, relayed through the bastion host chimera.
#
# Requirements:
# - SSH access to the network bastion.
# - The wol (Wake-On_LAN) package must be installed on the bastion.
#
# Usage: ./wake_crimson.sh

# DEBUG
# set -o xtrace

set -o nounset
set -o pipefail
set -o errexit

main() {
    declare -r bastion="chimera"
    declare -r target="54:a0:50:df:fe:f2"

    /usr/bin/ssh $bastion "/usr/bin/wol --port=9 $target"
}

main "$@"

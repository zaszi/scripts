#!/bin/env bash

# toggle_screenshare.sh
#
# Author: Zaszi - admin@zaszi.net
#
# A workaround script to toggle screen sharing on Sway. It captures the
# current screen in a video device and exposes it again as an XWayland window,
# allowing it to be shared as a window in various applications such as Discord
# and Google Meet.
#
# Source:
# https://gitlab.com/lelgenio/dotfiles/-/blob/master/dotfiles/scripts/sway-screenshare
#
# Requirements:
# - sway
# - v4l2loopback-dkms
# - wf-recorder
# - jq
#
# This script assumes your current user has sudo rights in order to load
# the l4d2loopback kernel module if it needs to.
#
# Usage: ./toggle_screenshare.sh

# DEBUG
# set -o xtrace

set -o nounset
set -o pipefail
set -o errexit

geometry() {
    windowGeometries=$(
        swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height - 1)"'
        swaymsg -t get_outputs -r | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'
    )
    echo "$windowGeometries"
}

main() {
    if ! lsmod | grep v4l2loopback >/dev/null; then
        sudo modprobe v4l2loopback
    fi

    if pgrep wf-recorder >/dev/null; then
        pkill -2 wf-recorder >/dev/null
        notify-send -t 2000 "Stopped screen sharing"
    else
        unset SDL_VIDEODRIVER
        geometry=$(geometry) || exit $?

        notify-send -t 2000 "Started screen sharing"
        wf-recorder -c rawvideo --geometry="$geometry" -m sdl -f pipe:wayland-mirror &

        swaymsg assign [ class=wf-recorder ] workspace 11
        swaymsg [ class=wf-recorder ] floating enable

    fi

}

main "$@"

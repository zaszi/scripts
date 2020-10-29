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
# - wf-recorder
# - ffmpeg
# - v4l2loopback-dkms
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
    if pgrep wf-recorder >/dev/null && pgrep ffplay >/dev/null; then
        if pgrep ffplay >/dev/null; then
            pkill ffplay >/dev/null
        fi
        if pgrep wf-recorder >/dev/null; then
            pkill wf-recorder >/dev/null
        fi
        notify-send -t 2000 "Stopped screen sharing"
    else
        if ! pgrep wf-recorder >/dev/null; then
            geometry=$(geometry) || exit $?
            wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video2 --geometry="$geometry" >/dev/null &
        fi
        if ! pgrep ffplay; then
            swaymsg assign [ class=ffplay ] workspace 11

            unset SDL_VIDEODRIVER
            ffplay /dev/video2 -fflags nobuffer -loglevel quiet &
            sleep 0.5
            swaymsg [ class=ffplay ] floating enable
        fi
        notify-send -t 2000 "Started screen sharing"
    fi
}

main "$@"

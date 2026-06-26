#!/usr/bin/bash
set -euo pipefail

mode="${1:-full}"
dir="$HOME/Pictures/Screenshots"
file="$dir/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"
mkdir -p "$dir"

case "$mode" in
    full)
        grim "$file"
        wl-copy < "$file"
        notify-send "Screenshot" "Copied to clipboard"
        ;;
    screen)
        output=$(slurp -o)
        [ -z "$output" ] && exit 1
        grim -g "$output" "$file"
        wl-copy < "$file"
        notify-send "Screenshot" "Copied to clipboard"
        ;;
    window)
        geometry=$(slurp)
        [ -z "$geometry" ] && exit 1
        grim -g "$geometry" "$file"
        wl-copy < "$file"
        notify-send "Screenshot" "Copied to clipboard"
        ;;
    edit)
        tmp=$(mktemp /tmp/screenshot-XXXXXX.png)
        geometry=$(slurp -b '#2E2A1E55' -c '#fb751bff')
        [ -z "$geometry" ] && exit 1
        grim -g "$geometry" "$tmp"
        wl-copy < "$tmp"
        satty -f "$tmp"
        [ -f "$tmp" ] && wl-copy < "$tmp" && mv "$tmp" "$file"
        notify-send "Screenshot" "Edited and copied to clipboard"
        ;;
esac

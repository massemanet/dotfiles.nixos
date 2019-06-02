#!/usr/bin/env bash

_bat() {
    local STATUS ENERGY POWER
    STATUS="$(cat /sys/class/power_supply/BAT0/status)"
    ENERGY="$(cat /sys/class/power_supply/BAT0/energy_now)"
    POWER="$(cat /sys/class/power_supply/BAT0/power_now)"
    [ "$POWER" -ne 0 ] && echo "${STATUS}[$(((60*ENERGY)/POWER))min]" || echo "$STATUS"
}
_net() {
    nmcli -t -g name conn show --active
}

_date() {
    date +'%Y-%m-%d'
}

_time() {
    date +'%H:%M:%S'
}

printf "%s : " "$(_net)" "$(_bat)" "$(_date)" "$(_time)"


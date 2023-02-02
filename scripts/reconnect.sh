#!/usr/bin/env bash

function log() {
    echo "$(TZ='Asia/Jakarta' date): ${1}"
}

function reconnect() {
    log "waiting for available ssid"
    while [[ $(nmcli device wifi list --rescan yes | grep -c Cita) == 0 ]]; do
        sleep 0.1
    done

    log "restarting network-manager"
    sudo systemctl restart snap.network-manager.networkmanager.service
    while [[ $(systemctl status snap.network-manager.networkmanager.service | grep -c 'active (running)') == 0 ]]; do
        sleep 0.1
    done

    log "connecting to Cita or Cita_Ext"
    {
        log "trying Cita_Ext"
        nmcli connection up netplan-wlp3s0-Cita_Ext &>/dev/null
        wait
        } || {
        log "trying Cita"
        nmcli connection up netplan-wlp3s0-Cita &>/dev/null
        wait
        } || {
        err=$?
        log "failed with status code ${err}"
        return "$err"
    }

    log "connected"

    return 0
}

function test_connection() {
    if ping -c 1 "${1}" &>/dev/null; then
        log "test ${1} succesful"
        return 0
    else
        log "test ${1} failed"
        return 1
    fi
}

function main() {
    address_list=(
        "1.1.1.1"
        "google.com"
        "100.100.100.100"
    )

    ctr=0
    for address in "${address_list[@]}"; do
        if test_connection "$address"; then
            ((ctr++))
        fi
    done

    if [[ ! $ctr -eq ${#address_list[@]} ]]; then
        reconnect
        sleep 30
    fi
}

main

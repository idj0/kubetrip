#!/usr/bin/env bash

function log() {
	echo "$(TZ='Asia/Jakarta' date): ${1}"
}

function reconnect() {
	if ping -c 1 1.1.1.1 &> /dev/null
	then
		log "connected"
	else
		log "disconnected"

		log "rescanning wifi"
		nmcli device wifi rescan

		log "waiting for available ssid"
		while [[ $(nmcli device wifi list | grep Cita | wc -l) == 0 ]]
		do
			sleep 1
		done

		log "connecting to Cita or Cita_Ext"
		{
			log "trying Cita"
			nmcli device wifi connect Cita &> /dev/null
		} || {
			log "trying Cita_Ext"
			nmcli device wifi connect Cita_Ext &> /dev/null
		} || {
			err=$?
			log "failed with status code ${err}"
			exit "${err}"
		}

		log "connected"
	fi
	echo "---"
}

reconnect

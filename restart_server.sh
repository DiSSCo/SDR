#!/bin/bash

function strEcho(){
    local exp=$1;
	echo -e "\033[1;32;41m${exp}\e[0m";
	echo "";
}

strEcho "Stopping Galaxy server"
sh ~/galaxy/run.sh --stop-daemon

strEcho "Restarting Galaxy server"
sh ~/galaxy/run.sh --daemon
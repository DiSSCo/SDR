#!/bin/bash

function strEcho(){
    local exp=$1;
	echo -e "\033[1;32;41m${exp}\e[0m";
	echo "";
}

strEcho "Updating repository"
git pull

strEcho "Stopping Galaxy server"
sh ~/galaxy/run.sh --stop-daemon

strEcho "Backing up config and tool folders"
TIMESTRING=$(date +%Y-%m-%d_%H:%M:%S)
mkdir -p ~/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}
cp -r ~/galaxy/config ~/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}
cp -r ~/galaxy/tools ~/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}

strEcho "Copying tool scripts"
cp -rf ~/SDR/galaxy-workflow/tools/* ~/galaxy/tools/sdr

#remove generated tool panel config file - this is regenerated at Galaxy boot time
strEcho "Updating configuration"
rm ~/galaxy/config/integrated_tool_panel.xml 

#copy tool panel config files
cp -f ~/SDR/galaxy-workflow/config/tool_conf.xml ~/galaxy/config/tool_conf.xml

#copy data type config files

strEcho "Restarting Galaxy server"
sh ~/galaxy/run.sh --daemon
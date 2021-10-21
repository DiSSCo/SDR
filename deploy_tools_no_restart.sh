#!/bin/bash

function strEcho(){
    local exp=$1;
	echo -e "\033[1;32;41m${exp}\e[0m";
	echo "";
}

strEcho "Updating repository"
git pull

strEcho "Backing up config and tool folders"
TIMESTRING=$(date +%Y-%m-%dT%H%M%S)
mkdir -p ~/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}/tools
rsync -av --exclude 'config/plugins' ~/galaxy/config ~/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING} #plugins directory is 1.5GB so don't back it up
rsync -av ~/galaxy/tools/sdr ~/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}/tools

strEcho "Copying tools"
cp -rf ~/SDR/galaxy-workflow/tools/* ~/galaxy/tools/sdr

strEcho "Updating configuration"
rm ~/galaxy/config/integrated_tool_panel.xml #remove generated tool panel config file - this is regenerated at Galaxy boot time

#copy tool panel config files
cp -f ~/SDR/galaxy-workflow/config/tool_conf.xml ~/galaxy/config/tool_conf.xml
cp -f ~/SDR/galaxy-workflow/config/sdr_tool_conf.xml ~/galaxy/config/sdr_tool_conf.xml

#copy main server config
cp -f ~/SDR/galaxy-workflow/config/galaxy.yml ~/galaxy/config/galaxy.yml

#copy data type config files
#!/bin/bash

function strEcho(){
    local exp=$1;
	echo -e "\033[1;32;41m${exp}\e[0m";
	echo "";
}

strEcho "Updating repository"
git pull

strEcho "Stopping Galaxy server"
sh /home/paulb1/galaxy/run.sh --stop-daemon

strEcho "Backing up config and tool folders"
TIMESTRING=$(date +%Y-%m-%dT%H%M%S)
mkdir -p /home/paulb1/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}/tools
rsync -av --exclude 'config/plugins' /home/paulb1/galaxy/config /home/paulb1/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING} #plugins directory is 1.5GB so don't back it up
rsync -av /home/paulb1/galaxy/tools/sdr /home/paulb1/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}/tools

strEcho "Copying tools"
cp -rf /home/paulb1/SDR/galaxy-workflow/tools/* /home/paulb1/galaxy/tools/sdr

strEcho "Updating configuration"
rm /home/paulb1/galaxy/config/integrated_tool_panel.xml #remove generated tool panel config file - this is regenerated at Galaxy boot time

#copy tool panel config files
cp -f /home/paulb1/SDR/galaxy-workflow/config/tool_conf.xml /home/paulb1/galaxy/config/tool_conf.xml
cp -f /home/paulb1/SDR/galaxy-workflow/config/sdr_tool_conf.xml /home/paulb1/galaxy/config/sdr_tool_conf.xml
cp -f /home/paulb1/SDR/galaxy-workflow/config/job_conf.xml /home/paulb1/galaxy/config/job_conf.xml
cp -f /home/paulb1/SDR/galaxy-workflow/config/local_env.sh /home/paulb1/galaxy/config/local_env.sh
cp -f /home/paulb1/SDR/galaxy-workflow/config/opends-schema.json /home/paulb1/galaxy/config/opends-schema.json

#copy main server config
cp -f /home/paulb1/SDR/galaxy-workflow/config/galaxy.yml /home/paulb1/galaxy/config/galaxy.yml

#copy data type files
cp -f /home/paulb1/SDR/galaxy-workflow/config/datatypes_conf.xml /home/paulb1/galaxy/config/datatypes_conf.xml

#copy visualisations
strEcho "Updating visualisations"
cp -rf /home/paulb1/SDR/galaxy-workflow/visualisations/roi /home/paulb1/galaxy/config/plugins/visualizations

#copy static content
strEcho "Updating statics"
cp -rf /home/paulb1/SDR/galaxy-workflow/static/* /home/paulb1/galaxy/static/

#copy data type config files

strEcho "Restarting Galaxy server"
sh /home/paulb1/galaxy/run.sh --daemon
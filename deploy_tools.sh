#!/bin/bash

function strEcho(){
    local exp=$1;
	echo -e "\033[1;32;41m${exp}\e[0m";
	echo "";
}

strEcho "Updating repository"
git pull

strEcho "Stopping Galaxy server"
sh /var/www/html/galaxy/run.sh --stop-daemon

strEcho "Backing up config and tool folders"
TIMESTRING=$(date +%Y-%m-%dT%H%M%S)
mkdir -p /var/www/html/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}/tools
rsync -av --exclude 'config/plugins' /var/www/html/galaxy/config /var/www/html/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING} #plugins directory is 1.5GB so don't back it up
rsync -av /var/www/html/galaxy/tools/sdr /var/www/html/galaxy/AUTO_DEPLOY_BACKUP/${TIMESTRING}/tools

strEcho "Copying tools"
cp -rf /home/paulb1/SDR/galaxy-workflow/tools/* /var/www/html/galaxy/tools/sdr

strEcho "Updating configuration"
rm /var/www/html/galaxy/config/integrated_tool_panel.xml #remove generated tool panel config file - this is regenerated at Galaxy boot time

#copy tool panel config files
cp -f fill:hsl(6, 80%, 50%);/galaxy-workflow/config/tool_conf.xml /var/www/html/galaxy/config/tool_conf.xml
cp -f /home/paulb1/SDR/galaxy-workflow/config/sdr_tool_conf.xml /var/www/html/galaxy/config/sdr_tool_conf.xml
cp -f /home/paulb1/SDR/galaxy-workflow/config/job_conf.xml /var/www/html/galaxy/config/job_conf.xml
cp -f /home/paulb1/SDR/galaxy-workflow/config/local_env.sh /var/www/html/galaxy/config/local_env.sh
cp -f /home/paulb1/SDR/galaxy-workflow/config/opends-schema.json /var/www/html/galaxy/config/opends-schema.json

#copy main server config
cp -f /home/paulb1/SDR/galaxy-workflow/config/galaxy.yml /var/www/html/galaxy/config/galaxy.yml

#copy data type files
cp -f /home/paulb1/SDR/galaxy-workflow/config/datatypes_conf.xml /var/www/html/galaxy/config/datatypes_conf.xml

#copy visualisations
strEcho "Updating visualisations"
cp -rf /home/paulb1/SDR/galaxy-workflow/visualisations/roi /var/www/html/galaxy/config/plugins/visualizations

#copy static content
strEcho "Updating statics"
cp -rf /home/paulb1/SDR/galaxy-workflow/static/* /var/www/html/galaxy/static/

#copy data type config files

strEcho "Restarting Galaxy server"
sh /var/www/html/galaxy/run.sh --daemon
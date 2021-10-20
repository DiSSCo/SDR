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

strEcho "Copying tool scripts"
cp -r ~/SDR/galaxy-workflow/tools/* ~/galaxy/tools/sdr

#remove generated tool panel config file - this is regenerated at Galaxy boot time
strEcho "Updating configuration"
rm ~/galaxy/config/integrated_tool_panel.xml 

#copy tool panel config files
cp  ~/SDR/galaxy-workflow/config/tool_conf.xml ~/galaxy/config/tool_conf.xml

#copy data type config files

strEcho "Restarting Galaxy server"
sh ~/galaxy/run.sh --daemon
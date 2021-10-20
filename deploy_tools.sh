function strEcho(){
    local exp=$1;
	echo "\033[1;32;41m${exp}\e[0m";
}


strEcho "Updating repository"
git pull

strEcho "Stopping Galaxy server"
sh ~/galaxy/run.sh --stop-daemon

strEcho "copying tool scripts"
cp -r ~/SDR/galaxy-workflow/tools/* ~/galaxy/tools/sdr

#remove generated tool panel config file - this is regenerated at Galaxy boot time
strEcho "Updating configuration"
rm ~/galaxy/config/integrated_tool_panel.xml 

#copy tool panel config files


#copy data type config files

strEcho "Restarting Galaxy server"
sh ~/galaxy/run.sh --daemon
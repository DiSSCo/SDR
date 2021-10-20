#make sure repo is up to date
git pull

#stop the galaxy server
sh ~/galaxy/run.sh --stop-daemon

#copy the tool scripts
cp -r ~/SDR/galaxy-workflow/tools/* ~/galaxy/tools/sdr

#remove generated config file
rm ~/galaxy/config/integrated_tool_panel.xml 

#copy config files


#start the galaxy server
sh ~/galaxy/run.sh --daemon
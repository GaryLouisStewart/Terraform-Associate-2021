#!/bin/bash
# stops and starts the consul agent on our local machine.

function start_consul_agent() {
    echo "Starting consul agent on localhost 127.0.0.1....."
    if [[ -f "config/consul-config.hcl" ]]; then
      consul agent -bootstrap -config-file="config/consul-config.hcl" -bind "127.0.0.1" > /dev/null 2>&1 &
      CONSUL_PID=$!
      echo "consul-agent started.... and consul PID: $CONSUL_PID"
    else
      echo "Error: cannot find config folder and consul-config.hcl file. Please make sure these are present."
      exit 1
    fi
    
    echo "Writing consul PID to pid file consul-pid.txt"
    echo $CONSUL_PID > ./consul-pid.txt
    
    echo "waiting 10 seconds for consul service to start.." 
    sleep 10

    echo "generating consul bootstrap token..."
    consul acl bootstrap --format=json > ./bootstrap-token.json
    
    # shellcheck disable=SC2002
    secret_id="$(cat bootstrap-token.json | jq -r .SecretID)"
    
    echo "$secret_id" > ./secret-id.txt

    echo "echo checking consul systemd service is running..."
    systemctl status consul.service
}



function stop_consul_agent() {
   read -rp "Are you sure you wish to stop the local consul-agent, please make sure there are no services using it...." HALT
   
   if [[ $HALT == "y" ]] || [[ $HALT == "Y" ]]; then
   	echo "stopping consul agent on localhost 127.0.0.1....."
        	
	local CONSUL_PID=$(cat ./consul-pid.txt)
	echo "$CONSUL_PID" | xargs kill
	echo "consul agent stopped..."

	read -rp "do you wish to clear the consul-data directory? yY or nN" CLEAR_DATA_DIR
	if [[ $CLEAR_DATA_DIR == "y" ]] || [[ $CLEAR_DATA_DIR == "Y" ]]; then
	   echo "removing all consul data directory under"
	   rm -rvf data/*
	   rm ./*.txt
        else
	     echo "not removing consul data directory..."
        fi	     
   else
        echo "option specified not equal to 'yY', aborting script."
        exit 1
   fi
}

function usage() {
       echo "Usage: [ -r, --run | -s, --stop,  | -h, --help]"
       echo "-r, --run, runs the consul server locally on 127.0.0.1, localhost address"
       echo "-s, --stop, stops the consul server that is running locally on 127.0.0.1, localhost address"
       echo "-h, --help, displays this help menu"
}

opt=$1
case $opt
in
     -r | --run)
     start_consul_agent
     ;;
     -s | --stop)
     stop_consul_agent
     ;;
     -h | --help)
     usage
     ;;
     *)
     echo "Command unknown, for more information, ./start_consul.sh -h"
     exit
     ;;     
esac

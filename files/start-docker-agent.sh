#!/bin/bash

usage () {

cat << EOF

	usage: $0 <options>

	OPTIONS:
        -h Show this message
        -r IP Address of Deepfence management console vm (Mandatory)

EOF
}

MGMT_CONSOLE_IP_ADDR=""

check_options () {
    if [ "$#" -lt 1 ]; then
        usage
        exit 0
    fi
    while getopts "r:h" opt; do
      case $opt in 
        h)
          usage
          exit 0
          ;;
        r)
          MGMT_CONSOLE_IP_ADDR=$OPTARG
          ;;
        *)
          usage
          exit 0
          ;;
      esac
    done
    if [ "$MGMT_CONSOLE_IP_ADDR" == "" ]; then
        usage
        exit 0
    fi
}


kill_agent () {
    agent_running=$(docker ps --format '{{.Names}}' | grep  "deepfence-agent")
    if [ "$agent_running" != "" ]; then
        docker rm -f deepfence-agent
    fi
}

start_agent() {
    docker run -dit --cpus=".2" --name=deepfence-agent --restart on-failure --pid=host --net=host --privileged=true -v /var/log/fenced -v /var/run/docker.sock:/var/run/docker.sock -v /:/fenced/mnt/host/:ro -v /sys/kernel/debug:/sys/kernel/debug:rw -e DF_BACKEND_IP="$MGMT_CONSOLE_IP_ADDR" deepfenceio/deepfence_agent_ce:latest
}


main () {
    check_options "$@"
    kill_agent
    start_agent
}

main "$@"


#!/bin/bash

ENV=test
SELECTION=""
USERNAME=""

function readUsername {
    echo "***************************"
    echo "* Reittiopas build tool   *"
    echo "***************************"
    echo ""
    echo "Please enter username in '$ENV'"
    echo ""
    printf "> "
    read USERNAME   
}

function printMenu {
    #clear
    echo "***************************"
    echo "* Reittiopas build tool   *"
    echo "***************************"
    echo ""
    echo "Build as user: $USERNAME@$ENV"
    echo ""
    echo "Please select action"
    echo "1) Build Load balancer"
    echo "2) Build Reverse proxy"
    echo "3) Build HSL-Now"
    echo "4) Build HSL-alert"
    echo "5) Build Navigator-proto"
    echo "6) Build Navigator-server"
    echo "7) Build Open Trip Planner"
    echo "8) Build Route server"
    echo "9) Build Siri2GTFS-RT"
    echo "r) Relaunch passive in '$ENV'"
    echo "c) Change passive to active in '$ENV'"
    echo "p) Print docker processes from '$ENV'"
    echo "s) Open SSH to '$ENV'"
    echo "q) Quit"
    echo ""
    printf "> "
}

function readInput {
    read SELECTION   
}

function printAction {
    clear
    echo "$1 as user $USERNAME@$ENV"
}

function selectAction {
    case $SELECTION in
        "1")
            printAction "Building load balancer"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-load-balancer.yaml -u $USERNAME
            ;;
        "2")
            printAction "Building Reverse proxy"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-reverse-proxy.yaml -u $USERNAME
            ;;
        "3")
            printAction "Building hsl-now"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-hsl-now.yaml -u $USERNAME
            ;;
        "4")
            printAction "Building hsl-alert"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-hsl-alert.yaml -u $USERNAM
            ;;
        "5")
            printAction "Building Navigator-proto"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-navigator-proto.yaml -u $USERNAME
            ;;
        "6")
            printAction "Building Navigator-server"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-navigator-server.yaml -u $USERNAME
            ;;
        "7")    
            printAction "Building Open Trip Planner"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-otp.yaml -u $USERNAME
            ;;
        "8")
            printAction "Building route server"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-route-server.yaml -u $USERNAME --ask-vault-pass
            ;;
        "9")
            printAction "Building Siri2GTFS-RT"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-siri2gtfsrt.yaml -u $USERNAME
            ;;
        "r")
            printAction "Running services"
            ansible-playbook -i environments/$ENV -K -s playbooks/run.yaml -u $USERNAME
            ;;
        "c")
            printAction "Changing passive to active"
            ansible-playbook -i environments/$ENV -K -s playbooks/change-environment.yaml -u $USERNAME
            ;;
        "s")
            ip=$(sed -n '2p' environments/$ENV)
            printAction "Opening SSH"
            ssh $USERNAME@$ip
            clear
            ;;
        "p") 
            ip=$(sed -n '2p' environments/$ENV)
            ssh -t $USERNAME@$ip "sudo docker ps"
            #clear
            ;;
        "q")
            exit 0
            ;;
        *)  clear
            ;;
    esac    
}

# Start

clear
readUsername
clear

while true
do
    printMenu
    readInput
    selectAction
done

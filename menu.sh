#!/bin/bash

ENV="dev"
ENV_DOMAIN="dev.digitransit.fi"
SELECTION=""
USERNAME=`whoami`

function readEnvironment {
    echo ""
    echo "Select enviroment"
    echo ""
    echo "1) Dev enviroment (dev.digitransit.fi)"
    echo "2) Test enviroment (matka.hsl.fi)"
    echo ""
    printf "> "
    read SELECTION
    case $SELECTION in
      "1")
          ENV="dev"
          ENV_DOMAIN="dev.digitransit.fi"
          ;;
      "2")
          ENV="test"
          ENV_DOMAIN="matka.hsl.fi"
          ;;
      *)
          readEnvironment
          ;;
    esac
}


function readUsername {
    echo ""
    printf "Enter username in '$ENV_DOMAIN' > "
    read USERNAME
}

function printMenu {
    #clear
    echo "***************************"
    echo "* Digitransit build tool  *"
    echo "***************************"
    echo ""
    echo "Build as user: $USERNAME@$ENV_DOMAIN"
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
    echo "10) Build Digitransit-ui"
    echo "12) "
    echo "13) "
    echo "14) Build Map Server"
    echo "15) "
    echo "16) Build raildigitraffic2gtfsrt"
    echo "17) Build Pelias-api"
    echo "18) Build Pelias-data-container"
    echo "r) Relaunch passive"
    echo "c) Change passive to active"
    echo "p) Print docker processes"
    echo "s) Open SSH"
    echo "u) Change username (current: '$USERNAME')"
    echo "e) Change environment (current: '$ENV_DOMAIN')"
    echo "q) Quit"
    echo ""
    printf "> "
}

function readInput {
    read SELECTION
}

function printAction {
    clear
    echo "$1 as user $USERNAME@$ENV_DOMAIN"
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
            ansible-playbook -i environments/$ENV -K -s playbooks/build-hsl-alert.yaml -u $USERNAME
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
        "10")
            printAction "Building Digitransit-ui"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-digitransit-ui.yaml -u $USERNAME --ask-vault-pass
            ;;
        "12")
            printAction "Deprecated"
            ;;
        "13")
            printAction "Deprecated"
            ;;
        "14")
            printAction "Building Map server"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-map-server.yaml -u $USERNAME
            ;;
        "15")
            printAction "Deprecated"
            ;;
        "16")
            printAction "digitraffic2gtfsrt"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-raildigitraffic2gtfsrt.yaml -u $USERNAME
            ;;
        "17")
            printAction "Building pelias-api"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-pelias-api.yaml -u $USERNAME
            ;;
        "18")
            printAction "Building pelias-data-container"
            ansible-playbook -i environments/$ENV -K -s playbooks/build-pelias-data-container.yaml -u $USERNAME
            ;;
        "r")
            printAction "Running services"
            ansible-playbook -i environments/$ENV -K -s playbooks/run.yaml -u $USERNAME --ask-vault-pass
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
        "u")
            readUsername
            clear
            ;;
        "e")
            readEnvironment
            clear
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

while true
do
    printMenu
    readInput
    selectAction
done

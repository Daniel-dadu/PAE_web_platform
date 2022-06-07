#!/usr/bin/env bash

#Hide ^C
stty -echoctl
#Catch signals 
trap ctrl_c INT


function ctrl_c() {
    end_all
    exit 0
}

function check_in_ignore(){
    local RESULT="0"
    local IGNOR_DIRS=("CLI/" "EncryptionFile/" "API-Gateway/" "Client/")

    for IGNOR_DIR in ${IGNOR_DIRS[@]}; do
        if  [ $1 = $IGNOR_DIR ]
        then
            RESULT="1"
            break
        fi
    done

    echo $RESULT
}

function search_services(){
    local LIST_HOLDER=($(ls -d */))

    for SERVICE in ${LIST_HOLDER[@]}; do
        if  [ $(check_in_ignore $SERVICE) = 0 ]
        then
            MICROSERVICES+=($SERVICE)
        fi
    done
}

function install_all(){
    for SERVICE in ${MICROSERVICES[@]}; do
        echo "Installing ${SERVICE::-1}"
        cd $SERVICE
        npm install
        cd ../
    done
}

function start_all(){
    for SERVICE in ${MICROSERVICES[@]}; do
        local SERVICE_NAME=${SERVICE::-1}
        local SERVICE_PID=""

        echo "Starting $SERVICE_NAME"
        cd $SERVICE
        
        if [ $VERBOSE = true ]
            then
                npm start &
            else
                npm start > /dev/null &
        fi

        SERVICE_PID=$!
        echo -e "::\tPID $SERVICE_PID"
        MICROSERVICES_PIDS+=($SERVICE_PID)

        cd ../
    done
}

function end_all(){
    for SERVICE in ${!MICROSERVICES_PIDS[@]}; do
        echo "Stopping ${MICROSERVICES[$SERVICE]::-1}"
        kill ${MICROSERVICES_PIDS[$SERVICE]}
    done
}

function main(){

    cd $WORKING_DIR

    search_services
    
    if [ $INSTALL_DEPS = true ]
        then
            install_all
    fi

    start_all

    echo "PRESS CTRL-C to exit"

    while true; do
        :
    done
}

function help(){
    echo "--i for install dependecies"
    echo "--D PATH for change working directory"
    echo "--h for help"
    echo "--v for print Node output"
}

WORKING_DIR=$PWD
MICROSERVICES=()
MICROSERVICES_PIDS=()

#Conditionals
INSTALL_DEPS=false
VERBOSE=false

while getopts :ihvD: opt
do
    case "${opt}" in
        i) 
            INSTALL_DEPS=true
            ;;
        D) 
            WORKING_DIR=${OPTARG}
            ;;
        :)
            echo "Error: --${OPTARG} requires an argument."
            exit 1
            ;;
        h)
            help
            exit 0
            ;;
        v)
            VERBOSE=true
            ;;
        *)
            help
            exit 0
            ;;
    esac
done

main

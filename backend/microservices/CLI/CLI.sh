#!/usr/bin/env bash

stty -echoctl # hide ^C
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
        cd $WORKING_DIR
    done
}

function start_all(){
    for SERVICE in ${MICROSERVICES[@]}; do
        local SERVICE_NAME=${SERVICE::-1}
        local SERVICE_PID=""

        echo "Starting $SERVICE_NAME"
        cd $SERVICE
        
        npm start&
        SERVICE_PID=$!
        echo -e "::\tPID $SERVICE_PID"
        MICROSERVICES_PIDS+=($SERVICE_PID)

        cd $WORKING_DIR
    done
}

function end_all(){
    for SERVICE in ${!MICROSERVICES_PIDS[@]}; do
        echo "Stopping ${MICROSERVICES[$SERVICE]::-1}"
        kill ${MICROSERVICES_PIDS[$SERVICE]}
    done
}

function main(){

    search_services
    install_all
    start_all

    echo "PRESS CTRL-C to exit"

    while true; do
        :
    done
}

WORKING_DIR=$PWD
MICROSERVICES=()
MICROSERVICES_PIDS=()

main

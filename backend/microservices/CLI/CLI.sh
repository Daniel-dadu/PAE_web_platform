#!/usr/bin/env bash

stty -echoctl # hide ^C
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo
    echo "Trapped CTRL-C"
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

function start(){
    for SERVICE in ${MICROSERVICES[@]}; do
        echo "Starting ${SERVICE::-1}"
        cd $SERVICE
        ls
        cd $WORKING_DIR
    done
}

WORKING_DIR=$PWD
MICROSERVICES=()

search_services
echo ${MICROSERVICES[@]}
#start
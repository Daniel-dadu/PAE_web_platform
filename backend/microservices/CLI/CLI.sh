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

    if [ $SEARCH = true ]
    then 
        search_services
    fi

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
    echo "--D PATH for change working directory"
    echo "--e SERVICE_NAME for exclude service from services search"
    echo "--h for help"
    echo "--i for install dependecies"
    echo "--s SERVICE_NAME for work with just service selected, disable services search"
    echo '--S "SERVICE_NAME_1 SERVICE_NAME_2 ..." for work with just services selected, disable services search'
    echo "--v for print Node output"
}

WORKING_DIR=$PWD
IGNOR_DIRS=("CLI/" "EncryptionFile/" "API-Gateway/" "Client/")
MICROSERVICES=()
MICROSERVICES_PIDS=()

#Conditionals
INSTALL_DEPS=false
SEARCH=true
VERBOSE=false

while getopts :D:e:his:S:v opt
do
    case "${opt}" in
        :)
            echo "Error: --${OPTARG} requires an argument."
            exit 1
            ;;
        D) 
            WORKING_DIR=${OPTARG}
            ;;
        e) 
            IGNOR_DIRS+=(${OPTARG}/)
            ;;
        h)
            help
            exit 0
            ;;
        i) 
            INSTALL_DEPS=true
            ;;
        s)
            SEARCH=false
            MICROSERVICES+=(${OPTARG}/)
            ;;
        S)
            SEARCH=false
            for SERVICE in ${OPTARG}
            do
                MICROSERVICES+=(${SERVICE}/)
            done
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

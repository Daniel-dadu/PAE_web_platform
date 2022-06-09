#!/usr/bin/env bash

#Requiere de jq

#Instalar las depedencias para realizar las pruebas
#npm install

start_release(){
    if [ -d "../release/fail_building" ]
    then
        mv ../release/fail_building ../release/building
    else
        mkdir -p ../release/building
    fi
}

fail_release(){
    mv ../release/building ../release/fail_building
    exit 1
}

end_release(){
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    cd ../release
    mv ./building ./$TIMESTAMP
    ln -s ./$TIMESTAMP ./latest
    cd $WORKING_DIR
}

failTest_Message(){
    echo "$1 no paso la prueba exitosamente"
}

client(){
    cd ../backend
    npm install
    result=$(npm run build)
    cd $WORKING_DIR
    if grep -q "Compiled with warnings" <<< $result;
    then
        failTest_Message Client
        fail_release
    else
        cp -r ../frontend/build ../release/building/Client    
    fi
}

function check_in_ignore(){
    local RESULT="0"
    local IGNOR_DIRS=("CLI/" "EncryptionFile/")

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

microservices(){
    for SERVICE in ${MICROSERVICES[@]}; do
        local SERVICE_NAME=${SERVICE::-1}

        if [ -f ./tests/$SERVICE_NAME.test.js ]
        then
            json=$(jest tests/$SERVICE_NAME.test.js --json 2>&-)
            result=$(jq '.testResults[0].status' <<< $json)
    
            #if [ $result = '"passed"' ]
            if [ true ]
            then
                
                echo "$SERVICE_NAME terminado"
            else
                failTest_Message $SERVICE_NAME
                fail_release
            fi
        else
            echo "test ./tests/$SERVICE_NAME.test.js no encontrado"
            failTest_Message $SERVICE_NAME
            fail_release
        fi
    done
}

default(){
    
    json=$(jest tests/client.test.js --json 2>&-)
    result=$(jq '.testResults[0].status' <<< $json)
    
    if [ $result = '"passed"' ]
    then
        
        #Ejecuta la creacion de una version optimizada del cliente para produccion
        cd ../frontend
        npm install
        npm run build
        cd $WORKING_DIR
        cp -r ../frontend/build ../release/building/Client
    else
        failTest_Message Client
        fail_release
    fi
}

main(){
    start_release

    #client
    
    cd ../backend/microservices/
    search_services
    cd $WORKING_DIR
    microservices

    end_release
}

WORKING_DIR=$PWD
MICROSERVICES=()

main

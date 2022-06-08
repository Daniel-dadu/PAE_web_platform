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
    mv ../release/building ../release/$TIMESTAMP
    ln -s ../release/$TIMESTAMP ../release/latest
}

failTest_Message(){
    echo "$1 no paso la prueba exitosamente"
}

client(){
    #Guarda la respuesta del test sin mostrar en la consola los mensajes
    json=$(jest tests/client.test.js --json 2>&-)
    result=$(jq '.testResults[0].status' <<< $json)
    
    if [ $result = '"passed"' ]
    then
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

    client
    
    

    end_release
}

WORKING_DIR=$PWD
main

#!/usr/bin/env bash

TEST=true

while getopts :f opt
do
    case "${opt}" in
        :)
            echo "Error: --${OPTARG} requiere un argumento."
            exit 1
            ;;
        f) 
            TEST=false
            ;;
    esac
done

#Requiere de jq
apt install jq -y &> /dev/null

start_release(){
    #Si ya existe una release fallida la reutiliza para generar la nueva
    if [ -d "../release/fail_building" ]
    then
        mv ../release/fail_building ../release/building
    else
        #Crea los directorios necesarios para generar la release
        mkdir -p ../release/building/pae
        mkdir -p ../release/building/pae/api
    fi
}

fail_release(){
    mv ../release/building ../release/fail_building
    exit 1
}

add_installer(){
    if [ -d "../installer" ]
    then
        cp -a ../installer/. ../release/building/
    fi
}

end_release(){
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    
    cd ../release
    #Nombra la version con el TIMESTAMP de finalizacion
    mv ./building ./$TIMESTAMP
    #Elimina los modulos instalados del paquete
    find ./$TIMESTAMP -name node_modules -type d -prune -exec rm -rf {} \;
    
    tar -cJf ./$TIMESTAMP.tar.xz ./$TIMESTAMP
    rm -r ./$TIMESTAMP
    
    if [ -L ./latest ]
    then
        rm ./latest
    fi
    ln -s ./$TIMESTAMP.tar.xz ./latest
    
    cd $WORKING_DIR
}

failTest_Message(){
    echo "$1 no paso la prueba exitosamente"
}

client(){
    #Va a al directorio del cliente
    cd ../frontend
    npm install
    #Crea una version optimizada del cliente
    result=$(npm run build)
    #Regresa al creador de version para continuar el proceso
    cd $WORKING_DIR
    #Evalua si es necesario evaluar el estado de la release
    if $TEST
    then
        #Evalua si la compilacion del cliente no tuvo warnings
        if grep -q "Compiled with warnings" <<< $result;
        then
            failTest_Message Client
            fail_release
        fi
    fi
    #Agrega el cliete a la release
    cp -r ../frontend/build/ ../release/building/pae/client/
    echo "CLient agregado"
}

function check_in_ignore(){
    local RESULT="0"
    local IGNOR_DIRS=("CLI/" )

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

        if $TEST
        then
            if [ -f ./tests/$SERVICE_NAME.test.js ]
            then
                json=$(jest tests/$SERVICE_NAME.test.js --json 2>&-)
                result=$(jq '.testResults[0].status' <<< $json)

                if [ $result != '"passed"' ]
                then
                    failTest_Message $SERVICE_NAME
                    fail_release
                fi
            else
                echo "test ./tests/$SERVICE_NAME.test.js no encontrado"
                failTest_Message $SERVICE_NAME
                fail_release
            fi
        fi
        #Agrega el microservicio a la release
        cp -r ../backend/microservices/$SERVICE ../release/building/pae/api/$SERVICE
        echo "$SERVICE_NAME agregado"
    done
}

main(){
    start_release

    client
    
    cd ../backend/microservices/
    search_services
    
    cd $WORKING_DIR
    microservices

    add_installer
    
    end_release
}

WORKING_DIR=$PWD
MICROSERVICES=()

main

#!/usr/bin/env bash

#client
#/var/pae/client
#apis
#/opt/pae/

#configurar
#   dominio remplazar 20.225.209.57
#   puerto del cliente
#   puerto de las apis

MODO=false
WORKING_DIR=$PWD
#Almacena la configuracion actual de las apis
CONFIG_FILE=$PWD/config.txt
#Almacena la configuracion deseada de las apis
NEW_CONFIG_FILE=$PWD/new_config.txt
#Almacena la configuracion anterior de las apis
OLD_CONFIG_FILE=$PWD/old_config.txt
DATABASE_FILE=$PWD/databaseArchitecture.sql

while getopts :mgc opt
do
    case "${opt}" in
        :)
            echo "Error: --${OPTARG} requiere un argumento."
            exit 1
            ;;
        m) 
            MODO=manual
            ;;
        g) 
            MODO=dialog
            ;;
        c) 
            MODO=config
            ;;
    esac
done

if [ $MODO = false ]
then 
    echo "No se escogio un modo de funcionamiento"
    echo "-m para ejecutarlo de forma manual"
    echo "-g para ejecutarlo con ventanas en la terminal"
    echo "-c para ejecutarlo con la configuracion en config.txt y new_config.txt"
    exit 1
fi
# --------------------------------------------
if [ $MODO = manual ] || [ $MODO = config ]
then
    echo "Instalando depedencias"
fi

INSTALL_DEB=$(apt install npm -y 2> /dev/null)
if [ $? != 0 ]
then
    echo "No se pudo instalar npm"
    exit 1
fi

INSTALL_DEB=$(apt install nginx -y 2> /dev/null)
if [ $? != 0 ]
then
    echo "No se pudo instalar nginx"
    exit 1
fi

npm install pm2 -g &> /dev/null

while true; do
    read -p "Desea instalar la base de datos (Si/No): " INSTALL_DB
    case $INSTALL_DB in
        [Ss]* )

            sudo -i -u postgres psql -c "CREATE ROLE pae WITH LOGIN PASSWORD 'devsoft_db_manager';"
            sudo -i -u postgres psql -c "ALTER ROLE pae CREATEDB;"
            sudo -i -u postgres psql -c "CREATE DATABASE pae_db OWNER pae;"
            sudo -i -u postgres psql -c "\c pae_db" -c "\i '$DATABASE_FILE'"
            break
            ;;
        [Nn]* )
            break
            ;;
        * ) echo "Ingrese si o no"
            ;;
    esac
done
# --------------------------------------------

#Almacena la configuracion de los puertos presentes
cd ./pae/api
APIS=($(ls -d */))
> $CONFIG_FILE

if [ $MODO = manual ] || [ $MODO = config ]
then
    echo "Obteniendo la configuracion de los puertos de las apis"
fi

for API in ${APIS[@]}; do
    if  [ $API != EncryptionFile/ ]
    then
        cd $API
        #cambiar los puertos
        grep -m 1 -F port ${API::-1}.js | gawk -v name=${API::-1} '{print name " " $4}' >> $CONFIG_FILE
        cd ../
    fi
done

if [ $MODO = config ] && [ ! -f $NEW_CONFIG_FILE ]
then
    echo "No se encontro $CONFIG_FILE"
    exit 1
fi

cp $CONFIG_FILE $OLD_CONFIG_FILE

cd $WORKING_DIR
# --------------------------------------------

#Configurar apis
cd ./pae/api

if [ $MODO = manual ] || [ $MODO = config ]
then
    echo "Configurando los puertos de las apis"
fi

for API in ${APIS[@]}; do
    if  [ $API != EncryptionFile/ ]
    then
        cd $API
        #optiene la configuracion de los puertos
        CONFIG_PORT=$(gawk -v name=${API::-1} '$0~name{print $2}' $CONFIG_FILE)
        
        #asignar nuevo puerto
        CONFIG_NEW_PORT=""

        case $MODO in
            manual|dialog)
                CONFIG_NEW_PORT=$CONFIG_PORT
                while true; do
                    read -p "Desea cambiar el puerto de ${API::-1}($CONFIG_PORT) (Si/No): " CHANGE
                    case $CHANGE in
                        [Ss]* )
                            while true; do
                                read -p "Ingrese un puerto para ${API::-1}: " CONFIG_NEW_PORT
                                if ! [[ $CONFIG_NEW_PORT =~ ^[0-9]+$ ]]
                                    then
                                    echo "Ingrese un puerto conformado unicamente por digitos"
                                else
                                    break
                                fi
                            done
                            break
                            ;;
                        [Nn]* )
                            break
                            ;;
                        * ) echo "Ingrese si o no"
                            ;;
                    esac
                done
                ;;
            config)
                CONFIG_NEW_PORT=$(gawk -v name=${API::-1} '$0~name{print $2}' $NEW_CONFIG_FILE)
                if ! [[ $CONFIG_NEW_PORT =~ ^[0-9]+$ ]]
                    then
                    echo "Puerto de ${API::-1} en la configurarion de entrada no esta conformado unicamente por digitos"
                    exit 1
                fi
                ;;
        esac

        #Actualiza la api
        sed -i "s/$CONFIG_PORT/$CONFIG_NEW_PORT/g" "${API::-1}.js"
        #Actualiza la configuracion
        sed -i "s/${API::-1} $CONFIG_PORT/${API::-1} $CONFIG_NEW_PORT/g" "$CONFIG_FILE"
        
        cd ../
    fi
done

# --------------------------------------------

#Instalar apis
if [ $MODO = manual ] || [ $MODO = config ]
then
    echo "Instalando las apis"
fi

mkdir -p /opt/pae/
rm -r /opt/pae/*
for API in ${APIS[@]}; do
    if  [ $API != Client/ ]
    then
        cd $API
        npm install &> /dev/null
        cd ../

        #copiar las apis al directorio destino
        cp -r $API /opt/pae/$API
    fi
done

#copia el administrador de las apis al directorio destino
cd $WORKING_DIR
cp -r CLI.sh /opt/pae/CLI.sh
cp pae.service /etc/systemd/system
systemctl daemon-reload
systemctl restart pae.service
# --------------------------------------------

#Instalar el cliente
cd pae/client/
#cambiar dominio
read -p "Indique la IP o dominio deseado: " IP_DOMAIN
find . -type f -exec sed -i -- "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$IP_DOMAIN/g" {} +

for API in ${APIS[@]}; do
    if  [ $API != EncryptionFile/ ]
    then
        #optiene la configuracion de los puertos
        CONFIG_PORT=$(gawk -v name=${API::-1} '$0~name{print $2}' $CONFIG_FILE)
        CONFIG_OLD_PORT=$(gawk -v name=${API::-1} '$0~name{print $2}' $OLD_CONFIG_FILE)
        echo "Asignar $CONFIG_PORT al $CONFIG_OLD_PORT"
        find . -type f -exec sed -i -- "s/:$CONFIG_OLD_PORT/:$CONFIG_PORT/g" {} +
    fi
done

cd ../
#copia el cliente en el directorio destino
mkdir -p /var/pae/client
cp -r client /var/pae/client
cp $WORKING_DIR/pae-site /etc/nginx/sites-available/pae
if [ -f /etc/nginx/sites-enabled/default ]
then
    rm /etc/nginx/sites-enabled/default
    rm /etc/nginx/sites-available/default
fi
if [ -L /etc/nginx/sites-enabled/pae ]
then
    rm /etc/nginx/sites-enabled/pae
fi
ln -s /etc/nginx/sites-available/pae /etc/nginx/sites-enabled/pae
systemctl restart nginx
cd ../
# --------------------------------------------

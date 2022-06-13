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

while getopts :mg opt
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
    esac
done

if [ $MODO = false ]
then 
    echo "No se escogio un modo de funcionamiento"
    echo "-m para ejecutarlo de forma manual"
    echo "-g para ejecutarlo con ventanas en la terminal"
    exit 1
fi
# --------------------------------------------
echo "Instalando depedencias"
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
# --------------------------------------------

IP="10.50.84.114"
PORTS=( 3093 3094 3031 80 0 3091 3095 3030 3092 3090 )

# --------------------------------------------
NUEVOS_PORTS=()

cd ./pae
APIS=($(ls -d */))
echo "Instalando APIs"
mkdir -p /opt/pae/
INDEX=0
for API in ${APIS[@]}; do
    if  [ $API != Client/ ]
    then
        cd $API
        npm install &> /dev/null
        #cambiar los puertos
        # sed -i -- "s/${PORTS[INDEX]}/${NUEVOS_PORTS[INDEX]}/g" ${API::-1}.js
        #cambiar dominio
        sed -i -- "s/20.225.209.57/$IP/g" ${API::-1}.js
        cd ../
        #mover las apis de lugar
        mv $API /opt/pae/$API
        #iniciar demonio
        pm2 start /opt/pae/$API/${API::-1}.js
    fi
    INDEX=$((INDEX+1))
done
pm2 startup
# --------------------------------------------

echo "Instalando sitio web"
cd Client
#cambiar puertos
# sed -i -- "s/${PORTS[3]}/${NUEVOS_PORTS[3]}/g" pae-site
#cambiar dominio
sed -i -- "s/20.225.209.57/$IP/g" *
mkdir -p /var/pae/client
cp -r ./pae/Client /var/pae/client
cp ./pae-site /etc/nginx/sites-available/pae
ln -s /etc/nginx/sites-available/pae /etc/nginx/sites-enabled/pae
cd ../
# --------------------------------------------
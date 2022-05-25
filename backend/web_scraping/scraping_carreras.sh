#!/usr/bin/env bash

#Ejecutar web scraping
#python3 scraping_carreras.py

#Filtra la lista de ufs de las carreras eliminando las lineas que continenen '(+)'
gawk -i inplace '!/[()]/' ./carrera/*

#Listar UFs
cat ./carrera/* > UFs_temp.txt

#Eliminar lineas vacias
gawk NF < UFs_temp.txt > UFs.txt

#Eliminar UFs repetidas
cp UFs.txt UFs_temp.txt
gawk '!repeat[$0]++' < UFs_temp.txt > UFs.txt
rm UFs_temp.txt

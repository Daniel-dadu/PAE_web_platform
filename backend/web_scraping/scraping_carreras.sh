#!/usr/bin/env bash

#Filtra la lista de ufs de las carreras eliminando las lineas que continenen '(+)'
gawk -i inplace '!/[()]/' ./carrera/*

#Listar UFs
cat ./carrera/* > UFs_temp.txt

#Eliminar divisiones de semestre
gawk -i inplace '!/Semestre/' UFs_temp.txt

#Eliminar lineas vacias
gawk NF < UFs_temp.txt > UFs.txt
rm UFs_temp.txt

#!/usr/bin/env bash

#Filtra la lista de ufs de las carreras eliminando las lineas que continenen '(+)'
gawk -i inplace '!/[()]/' ./carrera/*

#Listar UFs
cat ./carrera/* > UFs.txt

#Eliminar divisiones de semestre
gawk -i inplace '!/Semestre/' UFs.txt

#Eliminar lineas vacias
gawk -i NF UFs.txt

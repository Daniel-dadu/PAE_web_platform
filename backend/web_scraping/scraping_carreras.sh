#!/usr/bin/env bash

siglas="./carreras/carreras_siglas.txt"
nombres="./carreras/carreras_nombres.txt"
links="./carreras/carreras_links.txt"

#Filtra la lista de ufs de las carreras eliminando las lineas que continenen '(+)'
#gawk -i inplace '!/[()]/' ./carrera/*
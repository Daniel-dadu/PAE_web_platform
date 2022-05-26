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
python3 UFFilter.py
python3 UFClaveFilter.py
echo "Primer Semestre" > UFs.txt
cat ./UF/1.txt >> UFs.txt
echo "Segundo Semestre" >> UFs.txt
cat ./UF/2.txt >> UFs.txt
echo "Tercer Semestre" >> UFs.txt
cat ./UF/3.txt >> UFs.txt
echo "Cuarto Semestre" >> UFs.txt
cat ./UF/4.txt >> UFs.txt
echo "Quinto Semestre" >> UFs.txt
cat ./UF/5.txt >> UFs.txt
echo "Sexto Semestre" >> UFs.txt
cat ./UF/6.txt >> UFs.txt
echo "Séptimo Semestre" >> UFs.txt
cat ./UF/7.txt >> UFs.txt
echo "Octavo Semestre" >> UFs.txt
cat ./UF/8.txt >> UFs.txt
echo "Noveno Semestre" >> UFs.txt
cat ./UF/9.txt >> UFs.txt

rm UFs_temp.txt

python3 SQLMaker.py
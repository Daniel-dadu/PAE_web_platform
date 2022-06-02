#Creador de query de los datos recolectados

semestre = 1

semestres = [
"Primer Semestre",
"Segundo Semestre",
"Tercer Semestre",
"Cuarto Semestre",
"Quinto Semestre",
"Sexto Semestre",
"Séptimo Semestre",
"Octavo Semestre",
"Noveno Semestre",
]

semestreValue = {
"Primer Semestre" : 1,
"Segundo Semestre" : 2,
"Tercer Semestre" : 3,
"Cuarto Semestre" : 4,
"Quinto Semestre" : 5,
"Sexto Semestre" : 6,
"Séptimo Semestre" : 7,
"Octavo Semestre" : 8,
"Noveno Semestre" : 9
}

def Filter():
    UFList = open("./UFs.txt", "r")
    UFs = UFList.readlines()

    primer = ""
    segundo = ""
    tercer = ""
    cuarto = ""
    quinto = ""
    sexto = ""
    septimo = ""
    octavo = ""
    noveno = ""

    for i in range(len(UFs)):
        tempString = UFs[i].replace('\n', '').rstrip()
        if (tempString in semestres):
            semestre = semestreValue[tempString]

        else:
            UFData = tempString
            
            if (semestre == 1):
                primer += UFData + "\n"
            elif (semestre == 2):
                segundo += UFData + "\n"
            elif (semestre == 3):
                tercer += UFData + "\n"
            elif (semestre == 4):
                cuarto += UFData + "\n"
            elif (semestre == 5):
                quinto += UFData + "\n"
            elif (semestre == 6):
                sexto += UFData + "\n"
            elif (semestre == 7):
                septimo += UFData + "\n"
            elif (semestre == 8):
                octavo += UFData + "\n"
            else:
                noveno += UFData + "\n"

    Primer = open("./UF/1.txt", "w")
    Segundo = open("./UF/2.txt", "w")
    Tercer = open("./UF/3.txt", "w")
    Cuarto = open("./UF/4.txt", "w")
    Quinto = open("./UF/5.txt", "w")
    Sexto = open("./UF/6.txt", "w")
    Septimo = open("./UF/7.txt", "w")
    Octavo = open("./UF/8.txt", "w")
    Noveno = open("./UF/9.txt", "w")

    Primer.write(primer)
    Segundo.write(segundo)
    Tercer.write(tercer)
    Cuarto.write(cuarto)
    Quinto.write(quinto)
    Sexto.write(sexto)
    Septimo.write(septimo)
    Octavo.write(octavo)
    Noveno.write(noveno)

    UFList.close()
    Primer.close()
    Segundo.close()
    Tercer.close()
    Cuarto.close()
    Quinto.close()
    Sexto.close()
    Septimo.close()
    Octavo.close()
    Noveno.close()

Filter()
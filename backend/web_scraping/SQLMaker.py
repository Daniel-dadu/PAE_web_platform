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

def SQLCarrera():
    carrerasSiglas = open("./carreras/carreras_siglas.txt", "r")
    carrerasNombres = open("./carreras/carreras_nombres.txt", "r")
    #ignore_carreras.txt debe tener una lineas extra al final, para el correcto funcionamiento
    carrerasIgnore = open("./ignore_carreras.txt", "r")

    siglas = carrerasSiglas.readlines()
    ignore = carrerasIgnore.readlines()
    nombres = carrerasNombres.readlines()
    
    SQL = open("./SQL/Carrera.sql", "w")
    query = "INSERT INTO \"Carrera\" VALUES\n"

    n = len(siglas)
    for i in range(n):
        carrera = siglas[i].replace('\n', '').rstrip()
        if (carrera not in ignore):
            nombre = nombres[i].replace('\n', '').rstrip()
            query += "    ('" + carrera + "', '" + nombre + "')"
            if(i < n-1):
                query += ",\n"
            else:
                query += ";\n"
    
    carrerasSiglas.close()
    carrerasNombres.close()
    carrerasIgnore.close()
    SQL.write(query)
    SQL.close()

def SQLUF():
    UFList = open("./UFs.txt", "r")
    UFs = UFList.readlines()
    
    SQL = open("./SQL/UF.sql", "w")
    query = "INSERT INTO \"UnidadFormacion\" VALUES\n"

    n = len(UFs)
    i = 0
    while(i < n-1):
        tempString = UFs[i].replace('\n', '').rstrip()
        if (tempString in semestres):
            semestre = semestreValue[tempString]
            i += 1
        else:
            idUF = tempString
            nombreUF = UFs[i+1].replace('\n', '').rstrip()
            query += "    ('" + idUF + "', '" + nombreUF + "', " + str(semestre) + ")"
            if(i < n-2):
                query += ",\n"
            else:
                query += ";\n"
            i += 2

    UFList.close()
    SQL.write(query)
    SQL.close()

def SQLUnidadFormacionCarrera():
    carrerasSiglas = open("./carreras/carreras_siglas.txt", "r")
    #ignore_carreras.txt debe tener una lineas extra al final, para el correcto funcionamiento
    carrerasIgnore = open("./ignore_carreras.txt", "r")

    siglas = carrerasSiglas.readlines()
    ignore = carrerasIgnore.readlines()
    
    SQL = open("./SQL/UnidadFormacionCarrera.sql", "w")
    query = "INSERT INTO \"Carrera\" VALUES\n"

    n = len(siglas)
    for i in range(n):
        if (siglas[i] not in ignore):
            carrera = open("./carrera/" + siglas[i].replace('\n', '') + ".txt", "r")
            UFs = carrera.readlines()
            j = 0
            while(j < len(UFs)-1):
                tempString = UFs[j].replace('\n', '').rstrip()
                if (tempString not in semestres):
                    idUF = tempString
                    query += "    ('" + idUF + "', '" + siglas[i].replace('\n', '').rstrip() + "'),\n"
                    j += 1
                j += 1

            carrera.close()
    query = query.rstrip(query[-1])
    query = query.rstrip(query[-1])
    query += ";\n"

    carrerasSiglas.close()
    carrerasIgnore.close()
    SQL.write(query)
    SQL.close()

SQLCarrera()
SQLUF()
SQLUnidadFormacionCarrera()
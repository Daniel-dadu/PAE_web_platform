def Filter():
    for i in range(1, 10):
        UFList = open("./UF/"+str(i) +".txt", "r")
        UFs = UFList.readlines()

        UFsFiltered = ""
        claves = []
        j = 0
        while(j < len(UFs)):
            clave = UFs[j].replace('\n', '').rstrip()
            if(clave not in claves):
                claves.append(clave)
                nombre = UFs[j+1].replace('\n', '').rstrip()
                UFsFiltered += clave + "\n" + nombre + "\n" 
            j += 2

        UFList.close()
        UFFile = open("./UF/"+str(i) +".txt", "w")
        UFFile.write(UFsFiltered)


Filter()
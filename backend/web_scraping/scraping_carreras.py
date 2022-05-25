#Scraping para obtener las carreras ofrecidad
#http://sitios.itesm.mx/va/planes_de_estudio/2_1ES.htm
from scraping_carrera import scraping

carrerasLinks = open("./carreras/carreras_links.txt", "r")
carrerasSiglas = open("./carreras/carreras_siglas.txt", "r")
#ignore_carreras.txt debe tener una lineas extra al final, para el correcto funcionamiento
carrerasIgnore = open("./ignore_carreras.txt", "r")

links = carrerasLinks.readlines()
siglas = carrerasSiglas.readlines()
ignore = carrerasIgnore.readlines()
n = len(links)
m = len(ignore)
skipped = 0

print("Scraping", n-m, "websites:")
for i in range(n):
    if(siglas[i] in ignore):
        print("\t", i+1, "\tof\t", n, "... " , end="", flush=True)
        print("Skipped")
        skipped += 1

    else:
        print("\t", i+1, "\tof\t", n, "... ", end="", flush=True)
        save = open("./carrera/" + siglas[i].replace('\n', '') + ".txt", "w")
        content = scraping(links[i], 10)
        while(len(content) < 1):
            content = scraping(links[i], 30)    
        save.write(content)
        save.close
        print("Done")


carrerasLinks.close()
carrerasSiglas.close()
carrerasIgnore.close()

if(m == skipped):
    print("Finished")
    print(n-m, "websites scraped,", m, "websites ignored")
else:
    print("Error")
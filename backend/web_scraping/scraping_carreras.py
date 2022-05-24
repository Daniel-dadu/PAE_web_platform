#Scraping para obtener las carreras ofrecidad
#http://sitios.itesm.mx/va/planes_de_estudio/2_1ES.htm
from scraping_carrera import scraping
#directorio ./carrera
#a = scraping("https://samp.itesm.mx/Programas/VistaPrograma?clave=AMC19&modoVista=Default&idioma=ES&cols=0")
#print("a: ", a)

carrerasLinks = open("./carreras/carreras_links.txt", "r")
carrerasSiglas = open("./carreras/carreras_siglas.txt", "r")

links = carrerasLinks.readlines()
siglas = carrerasSiglas.readlines()
n = len(links)

print("Scraping ", n , "websites:")
for i in range(n):
    print("\t", i+1, " of ", n)
    save = open("./carrera/" + siglas[i].replace('\n', '') + ".txt", "w")
    save.write(scraping(links[i]))
    save.close

carrerasLinks.close()
carrerasSiglas.close()

print("Finish")
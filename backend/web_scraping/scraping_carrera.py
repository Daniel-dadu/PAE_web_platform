#Scraping para obtener las unidades de formacion de una carrera
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
from time import sleep

#//////////////////////////////////////////////////////////////////////////////
#Configuracion de web browser

opts = Options()
opts.binary_location = "/usr/bin/google-chrome"
opts.headless = True
chrome_driver = "./chromedriver"

driver = webdriver.Chrome(options=opts, executable_path=chrome_driver)
driver.set_page_load_timeout(10)

#//////////////////////////////////////////////////////////////////////////////

def scraping(URL):
    #Obtener la carrera
    #URL = "https://samp.itesm.mx/Programas/VistaPrograma?clave=AMC19&modoVista=Default&idioma=ES&cols=0"

    scrap = ""

    #//////////////////////////////////////////////////////////////////////////////
    #Renderizar la web dinamica

    driver.get(URL)
    sleep(10)

    #//////////////////////////////////////////////////////////////////////////////
    #Buscar las UF de la carrera
    
    soup = BeautifulSoup(driver.page_source, "html.parser")

    info = soup.find(id="divPeriodosES")
    semestres = info.find_all("table", class_="DIVPeriodoES")
    for semestre in semestres:
        #Nombre del semestre
        semestreNombre = semestre.find("div", class_="notaPeriodo h33 table-wrapper2")
        if(semestreNombre.text.strip() != "Semestre de Introducción"): #?
            scrap += semestreNombre.text.strip() + "\n"

            #UFs
            ufList = semestre.find_all("tr", class_="ClaveDescripcionod")
            for ufDescripcion in ufList:
                ufData = ufDescripcion.find_all("td" , class_="texto2")
                #clave
                scrap += ufData[0].text.strip() + "\n"
                #nombre
                scrap += ufData[1].text.strip() + "\n"
            
            scrap += "\n"
    
    return scrap
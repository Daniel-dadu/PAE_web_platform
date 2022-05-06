const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3094

const db = require('./queries')

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

// Obtener todas las carreras. NO REQUIERE JSON CON BODY.
app.get('/asesoria/get_carreras', db.getCarreras)


// Obtener lista de Unidades de Formación apartir de una carrera y semestre
/****** Ejemplo del JSON body: ******
{
    "carrera": "ITC",
    "semestre": 2
}
*/
app.get('/asesoria/get_uf/', db.getUF_carreraSemestre)


// Crear una nueva asesoría recibiendo su unidad de formación
/****** Ejemplo del JSON body: ******
{
    "asesorado": "A01657967",
    "uf": "TC1028"
}
*/
app.post('/asesoria/nueva/', db.setAsesoria)


// Editar la asesoría que se recibe poniendo la nueva duda que también se recibe en el JSON del body.
/****** Ejemplo del JSON body: ******
{
    "idAsesoria": 10,
    "duda": "No entiendo nada",
    "imagenes": ["Foto1", "Foto2", "Foto3"]
}
*/
app.put('/asesoria/nueva_duda/', db.setAsesoria_updateDuda)


app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
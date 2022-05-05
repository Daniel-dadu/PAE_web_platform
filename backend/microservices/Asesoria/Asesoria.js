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

app.get('/', (request, response) => {
    response.json({ info: 'Node.js, Express, and Postgres API for Asesorias' })
})

// Obtener todas las carreras
app.get('/asesoria/carreras', db.getCarreras)

// Obtener lista de Unidades de Formación apartir de una :carrera y :semestre
app.get('/asesoria/uf/:carrera/:semestre', db.getUF_carreraSemestre)

// Crear una nueva asesoría recibiendo su unidad de formación
app.post('/asesoria/nueva/:asesorado/:uf', db.setAsesoria)

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
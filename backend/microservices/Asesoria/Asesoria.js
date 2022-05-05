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

app.get('/asesoria/carreras', db.getCarreras)

app.get('/asesoria/uf/:carrera/:semestre', db.getUF_carreraSemestre)

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3095

const db = require('./queries')

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

app.get('/', (_request, response) => {
    response.json({ info: 'Node.js, Express, and Postgres API' })
})

/**
 * -- Propiedades:
 * @user se debe recibir el userID, es decir, la matrícula
 * @pass se debe recibir la contraseña del usuario
 * ejemplo: 
 * GET http://localhost:3095/login/validate/A01657967/ojito
 * 
 * -- Response:
 * Se regresa un JSON con las siguientes respuestas:
 * {"login-validateCredentials": "valid"}
 * {"login-validateCredentials": "invalid userID"}
 * {"login-validateCredentials": "invalid password"}
 */

app.get('/login/validate/:user/:pass', db.validateCredentials)


app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
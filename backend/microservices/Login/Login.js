const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3095

const db = require('./queries')

app.use(function (_req, res, next) {

    // Website you wish to allow to connect
    res.setHeader('Access-Control-Allow-Origin', '*');

    // Request methods you wish to allow
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    // Request headers you wish to allow
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');

    // Set to true if you need the website to include cookies in the requests sent
    // to the API (e.g. in case you use sessions)
    res.setHeader('Access-Control-Allow-Credentials', true);

    // Pass to next layer of middleware
    next();
});

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)


// Validar las credenciales del usuario, actualizar su campo de ultimaConexion y regresar el rol del usuario 
/****** Ejemplo del JSON body: ******
{
    "user": "A01657967",
    "password": "ojito"
}
 * -- Response:
 * Se regresa un JSON con las siguientes respuestas:
 * {"login-validateCredentials": "valid"}
 * {"login-validateCredentials": "invalid userID"}
 * {"login-validateCredentials": "invalid password"}
 */
app.put('/login/validate/', db.validateCredentials)


app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
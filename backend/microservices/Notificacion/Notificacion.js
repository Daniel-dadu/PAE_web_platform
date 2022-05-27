const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3030

const db = require('./queries')

// Documentación sobre el uso de CORS: https://expressjs.com/en/resources/middleware/cors.html
// Código copiado de: https://stackoverflow.com/questions/18310394/no-access-control-allow-origin-node-apache-port-issue

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
        extended: true
    })
)

// OBTENER LAS NOTIFICACIONES DE UN USUARIO
// Ejemplo de consulta GET:
// http://20.225.209.57:3030/notificacion/get_notificaciones/?idUsuario=A01657967
app.get('/notificacion/get_notificaciones/', db.get_notificaciones_usuario)


app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
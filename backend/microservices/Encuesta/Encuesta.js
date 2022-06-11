const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3096

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
        extended: true,
    })
)

// ========================= ENDPOINTS ========================= // 

// Obtener la encuesta con las preguntas para un 'asesor' / 'asesorado'
// Se debe indicar en el query parameter 'rol' el tipo de usuario del que se solicita la encuesta
// Ejemplo de solicitud de encuesta de asesores:
// http://20.225.209.57:3096/encuesta/get_encuesta/?rol=asesorado}
app.get('/encuesta/get_encuesta/', db.getEncuesta)

// Crear una respuesta a una encuesta
app.post('/encuesta/set_respuesta_encuesta/', db.setRespuestaEncuesta)

// ========================= ENDPOINTS ========================= // 

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
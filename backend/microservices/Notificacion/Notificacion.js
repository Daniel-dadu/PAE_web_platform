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

// OBTENER LOS ASESORES DISPONIBLES
// Ejemplo de consulta GET:
// http://20.225.209.57:3030/notificacion/get_asesoresDisponibles/?hora=17&dia=13&mes=6&anio=2022&nombreUF=Fotografía%20publicitaria%20y%20comercial
app.get('/notificacion/get_asesoresDisponibles/', db.get_asesoresDisponibles)

// Aceptar una asesoría recibiendo lo siguiente:
/****** Ejemplo del JSON body: ******
{
    "idAsesor": "A99999902",
    "nombreUF": "Desarrollo de software",
    "idAsesorado": "A01234599",
    "hora": 18,
    "dia": 16,
    "mes": 6,
    "anio": 2022,
    "lugar": "Algún lugar del mundo"
}
*/
// http://20.225.209.57:3030/notificacion/aceptarAsesoria
app.post('/notificacion/aceptarAsesoria/', db.aceptarAsesoria)

// Cancelar una asesoría recibiendo lo siguiente:
/****** Ejemplo del JSON body: ******
{
    "nombreUF": "Desarrollo de software",
    "idAsesorado": "A01234599",
    "hora": 18,
    "dia": 16,
    "mes": 6,
    "anio": 2022
}
*/
// http://20.225.209.57:3030/notificacion/cancelarAsesoria
app.post('/notificacion/cancelarAsesoria/', db.cancelarAsesoria)


app.post('/notificacion/enviarNotificacion_directivos', db.enviarNotificacionDirectivos)

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
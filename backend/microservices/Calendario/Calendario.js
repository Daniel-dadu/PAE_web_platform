const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3031

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

// OBTENER LAS ASESORÍAS DE UN USUARIO
// Ejemplo de consulta GET:
// http://20.225.209.57:3031/calendario/get_asesorias/?idUsuario=A01657967&mes=2&anio=2022
app.get('/calendario/get_asesorias/', db.get_asesorias_usuario)

// OBTENER LAS ASESORÍAS DE TODOS LOS USUARIOS
// Ejemplo de consulta GET:
// http://20.225.209.57:3031/calendario/get_allAsesorias/?mes=2&anio=2022
app.get('/calendario/get_allAsesorias/', db.get_allAsesorias)

// OBTENER LA INFORMACIÓN DE LA ASESORÍA DE UN USUARIO
// Ejemplo de consulta GET:
// http://20.225.209.57:3031/calendario/get_informacionAsesoria/?idUsuario=A94949494&hora=10&dia=1&mes=6&anio=2022
app.get('/calendario/get_informacionAsesoria/', db.get_informacionAsesoria)

// OBTENER LAS ASESORÍAS DE UN ASESOR POR DÍA
// Ejemplo de consulta GET:
// http://20.225.209.57:3031/calendario/get_asesoriasIndividuales/?dia=25&mes=2&anio=2022
app.get('/calendario/get_asesoriasIndividuales/', db.get_asesoriasIndividuales)

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
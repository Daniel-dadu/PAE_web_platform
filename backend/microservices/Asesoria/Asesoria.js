const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3094

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

// --- OBTENER LISTA DE UFs A PARTIR DE LA CARRERA Y SEMESTRE ---
// Obtener lista de Unidades de Formación apartir de una carrera y semestre
// Ejemplo de consulta con query params:
// http://20.225.209.57:3094/asesoria/get_uf/?carrera=ITC&semestre=1
app.get('/asesoria/get_uf/', db.getUF_carreraSemestre)


app.get('/asesoria/get_dias/', db.getDiasDisponibles)


app.get('/asesoria/get_horas/', db.getHorasDisponibles)


// Crear una nueva asesoría recibiendo lo siguiente (regresa el ID de la asesoría)
/****** Ejemplo del JSON body: ******
{
    "uf": "TC1028",
    "anio": 2022,
    "mes": 3,
    "dia": 15,
    "hora": 10,
    "duda": "otra prueba x4",
    "asesorado": "A01657967"
}
*/
app.post('/asesoria/nueva/', db.createAsesoria)

// Insertar una imagen de una asesoría ya creada (no regresa nada)
/****** Ejemplo del JSON body: ******
{
    "idAsesoria": 1,
    "imagen": "data:image/jpeg;base64..."
}
*/
app.post('/asesoria/insertar_imagen', db.insertImagen)

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
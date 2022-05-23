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

// --- OBTENER LISTA DE CARRERAS ---
// Obtener todas las carreras. NO REQUIERE QUERY PARAMS.
app.get('/asesoria/get_carreras', db.getCarreras)


// --- OBTENER LISTA DE UFs A PARTIR DE LA CARRERA Y SEMESTRE ---
// Obtener lista de Unidades de Formación apartir de una carrera y semestre
// Ejemplo de consulta con query params:
// http://20.225.209.57:3094/asesoria/get_uf/?carrera=ITC&semestre=1
app.get('/asesoria/get_uf/', db.getUF_carreraSemestre)


// Obtener lista de días con asesores disponibles para dar asesoría en la unidad de formación proporcionada
/****** Ejemplo del JSON body: ******
{
    "uf": "TC1028"
}
*/
app.get('/asesoria/get_dias/', db.getDias_uf)


// Obtener lista de horas disponibles para dar asesoría en la unidad de formación y día proporcionado
/****** Ejemplo del JSON body: ******
{
    "uf": "TC1028",
    "dia": "2022-05-10"
}
*/
app.get('/asesoria/get_horas/', db.getHoras_ufDia)


// Obtener lista de horas disponibles para dar asesoría en la unidad de formación y día proporcionado
/****** Ejemplo del JSON body: ******
{
    "idAsesoria": 10
}
*/
app.get('/asesoria/get_uf_fecha_hora/', db.getInfo_ufFechaHora)


// Crear una nueva asesoría recibiendo su unidad de formación
/****** Ejemplo del JSON body: ******
{
    "asesorado": "A01657967",
    "uf": "TC1028"
}
*/
app.post('/asesoria/nueva/', db.createAsesoria)


// Editar la asesoría que se recibe poniendo la nueva duda que también se recibe en el JSON del body.
/****** Ejemplo del JSON body: ******
{
    "idAsesoria": 10,
    "duda": "No entiendo nada",
    "imagenes": ["Foto1", "Foto2", "Foto3"]
}
*/
app.put('/asesoria/nueva_duda/', db.setAsesoria_updateDuda)


// Editar la asesoría que se recibe poniendo el nuevo horario (idHorarioDisponible) que se recibe.
/****** Ejemplo del JSON body: ******
{
    "idAsesoria": 10,
    "idHorarioDisponible": 1 
}
*/
app.put('/asesoria/nueva_fechahora/', db.setAsesoria_updateFechaHora)


// Editar el status de un horario para que esté 'reservada' a partir del idHorarioDisponible que se recibe.
/****** Ejemplo del JSON body: ******
{
    "idHorarioDisponible": 1 
}
*/
app.put('/asesoria/reservar_horario/', db.setAsesoria_reservarHorario)


// Elimina una asesoría a partir de su id.
/****** Ejemplo del JSON body: ******
{
    "idAsesoria": 10
}
*/
app.delete('/asesoria/eliminar', db.deleteAsesoria)

app.listen(port, '0.0.0.0', () => {
    console.log(`App running on port ${port}.`)
})
const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3090

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

// ---------- ENDPOINT DE PRUEBA ----------------
/* Para probar subir una imagen en base64 a la DB
Esto se hará en la imagen de perfil de un usuario:
Se recibe un JSON con la matrícula del usuario y la imagen en base64
Y se actualiza la imagen en la base de datos
EJEMPLO DEL JSON BODY:
{
    "matricula": "A01657967",
    "fotoPerfil": "data:image/png;base64..." 
}
*/
app.put('/registro/prueba_foto', db.prueba_fotoPerfil)

// ---------- ENDPOINT DE PRUEBA ----------------
/* Para probar que una imagen se haya subido correctamente
Se recibe como QUERY PARAMETER la matrícula del alumno del que se quiere conocer su foto
EJEMPLO: http://20.225.209.57:3090/registro/prueba_get_foto?matricula=A01657967
*/
app.get('/registro/prueba_get_foto', db.prueba_getfotoPerfil)


app.get('/registro/politica_vigente', db.politica_vigente)


app.post('/registro/nuevo_asesorado', db.nuevo_asesorado)


app.post('/registro/nuevo_asesor', db.nuevo_asesor)


app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
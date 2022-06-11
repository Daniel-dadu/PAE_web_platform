const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
    user: 'pae',
    host: 'localhost',
    database: 'pae_db',
    password: 'devsoft_db_manager',
    port: 5432,
})

const getEncuesta = (request, response) => {

    const rolUser = request.query.rol

    const consultaTitleDescripcion = `SELECT "idEncuesta", "titulo", "descripcion" FROM "Encuesta" WHERE "rol" = $1`

    pool.query(consultaTitleDescripcion, [rolUser], (error, result) => {
        if(error) {
            response.status(400).send("Error: no se pudo obtener la ancuesta de asesorados")
        } else {
            const consultaPreguntas = `SELECT "idPregunta", "tipo" AS "tipoDePregunta", "pregunta", "opcionesRespuesta" AS opciones FROM "Pregunta" WHERE "idEncuesta" = $1`

            pool.query(consultaPreguntas, [result.rows[0].idEncuesta], (error, results) => {
                if(error) {
                    response.status(400).send("Error: no se pudo obtener la ancuesta de asesorados")
                } else {
                    response.status(200).json(
                        {
                            titulo: result.rows[0].titulo, 
                            descripcion: result.rows[0].descripcion, 
                            preguntas: results.rows
                        }
                    )
                }
            })
        }
    })
}

module.exports = {
    getEncuesta
}
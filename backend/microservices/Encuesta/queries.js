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
            response.status(400).send("Error: no se pudo obtener la encuesta")
        } else {
            const consultaPreguntas = `SELECT "idPregunta", "tipo" AS "tipoDePregunta", "pregunta", "opcionesRespuesta" AS opciones FROM "Pregunta" WHERE "idEncuesta" = $1`

            pool.query(consultaPreguntas, [result.rows[0].idEncuesta], (error, results) => {
                if(error) {
                    response.status(400).send("Error: no se pudo obtener la encuesta")
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

const setRespuestaEncuesta = (request, response) => {
    const idAsesoria = request.body.idAsesoria
    const rolUser = request.body.rol
    const respuestas = request.body.respuestas
    const fotoEvidencia = request.body.fotoEvidencia

    ;(async () => {

        const client = await pool.connect()

        try {

            await client.query('BEGIN')

            const consulta1 = `SELECT "idCalificacionEncuesta" FROM "CalificacionEncuesta" INNER JOIN "Encuesta" ON "CalificacionEncuesta"."idEncuesta" = "Encuesta"."idEncuesta" WHERE "idAsesoria" = $1 AND "rol" = $2`
            const getIdCalificacionEncuesta = await client.query(consulta1, [idAsesoria, rolUser])

            const idCalificacionEncuesta = getIdCalificacionEncuesta.rows[0].idCalificacionEncuesta

            const consulta2 = `INSERT INTO "CalificacionPregunta" ("idCalificacionPregunta", "idCalificacionEncuesta", "idPregunta", "respuesta") VALUES (DEFAULT, $1, $2, $3)`
            for (let idPregunta in respuestas) {
                const arr = [idCalificacionEncuesta, parseInt(idPregunta), respuestas[idPregunta]]
                await client.query(consulta2, arr)
            }

            const consulta3 = `UPDATE "CalificacionEncuesta" SET "estado" = 'realizada', "fotoEvidencia" = $2, "fecha" = CURRENT_TIMESTAMP WHERE "idCalificacionEncuesta" = $1`
            await client.query(consulta3, [idCalificacionEncuesta, fotoEvidencia])

            // ================= FIN TRANSACCION ================= //
            await client.query('COMMIT')
            response.status(200).send("La respuesta a la encuesta se guardó exitosamente")
            // ================= FIN TRANSACCION ================= //

        } catch (e) {
            await client.query('ROLLBACK')
            throw e
            
        } finally {
            client.release()
        }

    })().catch(_e => 
        response.status(400).send('Error: No se pudo registrar la respuesta a la encuesta (transacción cancelada correctamente)')
    )

}

const getRespuestaEncuesta = (request, response) => {
    const idAsesoria = request.query.idasesoria
    const matricula = request.query.matriculaencuestado

    const consulta1 = `SELECT idencuesta as "idEncuesta", tituloencuesta AS titulo, descripcionencuesta AS descripcion, fotoe AS "fotoEvidencia" FROM get_info_encuesta($1, $2)`

    pool.query(consulta1, [idAsesoria, matricula], (error, result) => {
        if(error) {
            response.status(400).send('Error: No se pudo obtener la respuesta de la encuesta')
        } else {
            // response.status(200).json(result.rows[0])

            const consultaPreguntas = `
                SELECT 
                    "tipo" AS "tipoDePregunta",
                    "pregunta",
                    "opcionesRespuesta" AS opciones,
                    "respuesta"
                FROM 
                    "CalificacionEncuesta", 
                    "Encuesta", 
                    "Pregunta", 
                    "CalificacionPregunta" 
                WHERE 
                    "CalificacionEncuesta"."idEncuesta" = "Encuesta"."idEncuesta" AND 
                    "Pregunta"."idEncuesta" = "Encuesta"."idEncuesta" AND 
                    "Pregunta"."idPregunta" = "CalificacionPregunta"."idPregunta" AND 
                    "Encuesta"."idEncuesta" = $1 AND 
                    "idAsesoria" = $2;
            `

            pool.query(consultaPreguntas, [result.rows[0].idEncuesta, idAsesoria], (error, results) => {
                if(error) {
                    response.status(400).send("Error: No se pudo obtener la respuesta de la encuesta")
                } else {
                    response.status(200).json(
                        {
                            titulo: result.rows[0].titulo, 
                            descripcion: result.rows[0].descripcion, 
                            fotoEvidencia: result.rows[0].fotoEvidencia, 
                            preguntas: results.rows
                        }
                    )
                }
            })
        }
    })

}

module.exports = {
    getEncuesta,
    setRespuestaEncuesta,
    getRespuestaEncuesta
}
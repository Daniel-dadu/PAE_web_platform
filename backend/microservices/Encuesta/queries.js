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

const setRespuestaEncuesta = (request, response) => {
    const idAsesoria = request.body.idAsesoria
    const rolUser = request.body.rol
    const respuestas = request.body.respuestas

    ;(async () => {

        const client = await pool.connect()

        try {

            await client.query('BEGIN')

            const consulta1 = `SELECT "idCalificacionEncuesta" FROM "CalificacionEncuesta" INNER JOIN "Encuesta" ON "CalificacionEncuesta"."idEncuesta" = "Encuesta"."idEncuesta" WHERE "idAsesoria" = $1 AND "rol" = $2`

            const getIdCalificacionEncuesta = await client.query(consulta1, [idAsesoria, rolUser])

            const consulta2 = `INSERT INTO "CalificacionPregunta" ("idCalificacionPregunta", "idCalificacionEncuesta", "idPregunta", "respuesta") VALUES (DEFAULT, $1, $2, $3)`

            for (let idPregunta in respuestas) {
                // const idCalEncuesta = getIdCalificacionEncuesta.rows[0].idCalificacionEncuesta
                // const idPreguntaInt = parseInt(idPregunta)
                // const respuestaPreg = respuestas[idPregunta]
                // const arr = [idCalEncuesta, idPreguntaInt, respuestaPreg]
                const arr = [getIdCalificacionEncuesta.rows[0].idCalificacionEncuesta, parseInt(idPregunta), respuestas[idPregunta]]
                // console.log("arr", arr)
                await client.query(consulta2, arr)
                // console.log("ojo", idRes.rows[0])
            }

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

module.exports = {
    getEncuesta,
    setRespuestaEncuesta
}
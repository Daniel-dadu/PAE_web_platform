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
    const rolUser = request.query.rol

    const consulta1 = `
        SELECT 
            idencuesta as "idEncuesta", 
            tituloencuesta AS titulo, 
            descripcionencuesta AS descripcion, 
            fotoe AS "fotoEvidencia" 
        FROM 
            get_info_encuesta($1, $2, $3)
    `

    pool.query(consulta1, [idAsesoria, matricula, rolUser], (error, result) => {
        if(error || result.rows[0] === undefined) {
            response.status(400).send('Error: No se pudo obtener la respuesta de la encuesta')
        } else {

            const consultaPreguntas = `
            SELECT 
                "tipo" AS "tipoDePregunta",
                "pregunta",
                "opcionesRespuesta" AS opciones,
                "respuesta"
            FROM 
                "CalificacionEncuesta"
                INNER JOIN "Asesoria" USING("idAsesoria")
                INNER JOIN "Encuesta" USING("idEncuesta")
                INNER JOIN "Pregunta" USING("idEncuesta") 
                INNER JOIN "CalificacionPregunta" USING ("idCalificacionEncuesta", "idPregunta")
            WHERE
                "idAsesoria" = $1 AND
                "rol" = $2;
            `
            pool.query(consultaPreguntas, [idAsesoria, rolUser], (error, results) => {
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

const getEncuestasRespondidas = (request, response) => {
    // const matricula = request.query.matricula
    const rolUser = request.query.rol

    const tipoId = rolUser === 'asesor' ? '"idAsesor"' : '"idAsesorado"'

    const consulta1 = `
        SELECT 
            DISTINCT ${tipoId},
            CONCAT("nombreUsuario", ' ', "apellidoPaterno") AS "nombreUsuario"
        FROM 
            "CalificacionEncuesta"
            INNER JOIN "Encuesta" USING("idEncuesta")
            INNER JOIN "Asesoria" USING("idAsesoria")
            INNER JOIN "Usuario" ON ${tipoId} = "idUsuario"
        WHERE
            "estado" = 'realizada' AND
            "Encuesta"."rol" = $1
    `

    pool.query(consulta1, [rolUser], async (error, results1) => {
        if(error) {
            response.status(400).send("Error: No se pudo obtener la información de las encuestas")
        } else {
            const encuestados = results1.rows

            let listaFinal = []

            const consulta2 = `
                SELECT 
                    "idAsesoria", 
                    "idUF" AS "claveUF",
                    "fecha" AS "horaRespuestaEncuesta",
                    "fechaHora" AS "horaAsesoria",
                    CONCAT(${rolUser === 'asesor' ? '"idAsesorado"' : '"idAsesor"' }, ' fue el ${rolUser === 'asesor' ? 'asesorado' : 'asesor'}.') AS contenido
                FROM 
                    "CalificacionEncuesta" 
                    INNER JOIN "Encuesta" USING("idEncuesta")
                    INNER JOIN "Asesoria" USING("idAsesoria")
                    INNER JOIN "HorarioDisponible" USING("idHorarioDisponible")
                WHERE
                    "rol" = $1 AND
                    "estado" = 'realizada' AND
                    ${tipoId} = $2;
            `

            for (let encuestado of encuestados) {

                const matriculaUser = encuestado[rolUser === 'asesor' ? 'idAsesor' : 'idAsesorado']
                
                const results2 = await pool.query(consulta2, [rolUser, matriculaUser])

                const formatDateSting = datePSQL => new Date(datePSQL.slice(0, -1)).toLocaleString()

                listaFinal.push({
                    nombreUsuario: encuestado.nombreUsuario,
                    matricula: matriculaUser,
                    respuestasEncuestas: results2.rows.map(encuesta => ({
                        idAsesoria: encuesta.idAsesoria,
                        claveUF: encuesta.claveUF,
                        horaRespuestaEncuesta: formatDateSting(String(encuesta.horaRespuestaEncuesta)),
                        horaAsesoria: formatDateSting(String(encuesta.horaAsesoria)),
                        contenido: encuesta.contenido
                    }))
                })
            }

            response.status(200).json(listaFinal)
        }
    })
}

module.exports = {
    getEncuesta,
    setRespuestaEncuesta,
    getRespuestaEncuesta,
    getEncuestasRespondidas
}
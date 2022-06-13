const { request, response } = require('express')
const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'pae',
  host: 'localhost',
  database: 'pae_db',
  password: 'devsoft_db_manager',
  port: 5432
})

const get_notificaciones_usuario = (request, response) => {
    
    const id = request.query.idUsuario

    if(id === "null") {
        response.status(400).json([])
        return
    }

    const consulta = `SELECT * FROM get_notificaciones_usuario($1);` // SELECT * FROM get_notificaciones_usuario('A01657967');

    pool.query(consulta, [id], (error, result) => {
        if(error) {
            console.log(error)
        } else {
            response.status(200).json({'notificaciones': result.rows})
            // console.log(result.rows)
        }
    })

}

const get_asesoresDisponibles = (request, response) => {

    const hora = request.query.hora
    const dia = request.query.dia
    const mes = request.query.mes
    const anio = request.query.anio
    const nombreUF = request.query.nombreUF

    if(hora === "null" || dia === "null" || mes === "null" || anio === "null" || nombreUF === "null") {
        response.status(400).json([])
        return
    }

    const consulta = `SELECT * FROM get_asesoresDisponibles($1, $2, $3, $4, $5);` // SELECT * FROM get_asesoresDisponibles(17, 13, 6, 2022, 'Fotografía publicitaria y comercial');

    pool.query(consulta, [hora, dia, mes, anio, nombreUF], (error, result) => {
        if(error) {
            console.log(error)
        } else {
            response.status(200).json({'asesoresDisponibles': result.rows})
            // console.log(result.rows)
        }
    })

}

const aceptarAsesoria = (request, response) => {

    const idAsesor = request.body.idAsesor
    const nombreUF = request.body.nombreUF
    const idAsesorado = request.body.idAsesorado
    const hora = request.body.hora
    const dia = request.body.dia
    const mes = request.body.mes
    const anio = request.body.anio
    const lugar = request.body.lugar

    const consulta = `CALL aceptarAsesoria($1, $2, $3, $4, $5, $6, $7, $8);`
    const params = [idAsesor, nombreUF, idAsesorado, hora, dia, mes, anio, lugar]

    pool.query(consulta, params, (error) => {
        if(error) {
            response.status(409).send('Ocurrió un error al aceptar la asesoría.')
        } else {
            response.status(200).send('Se confirmó la asesoría correctamente')
        }
    })
    
}

const cancelarAsesoria = (request, response) => {

    const nombreUF = request.body.nombreUF
    const idAsesorado = request.body.idAsesorado
    const hora = request.body.hora
    const dia = request.body.dia
    const mes = request.body.mes
    const anio = request.body.anio

    const consulta = `CALL cancelarAsesoria($1, $2, $3, $4, $5, $6);`
    const params = [nombreUF, idAsesorado, hora, dia, mes, anio]

    pool.query(consulta, params, (error) => {
        if(error) {
            response.status(409).send('Ocurrió un error al cancelar la asesoría.')
        } else {
            response.status(200).send('Se canceló la asesoría correctamente')
        }
    })
    
}

const enviarNotificacionDirectivos = (request, response) => {
    const destinatario = request.body.destinatario
    const asunto = request.body.asunto
    const mensaje = request.body.mensaje

    pool.query(`CALL enviarNotificaciones($1,$2,$3)`, [destinatario, asunto, mensaje], (error) => {
        if(error) {
            response.status(409).send('Ocurrió un error al enviar la notificación.')
        } else {
            response.status(200).send('Se envió la notificacion correctamente')
        }
    })
}

module.exports = {
    get_notificaciones_usuario,
    get_asesoresDisponibles,
    aceptarAsesoria,
    cancelarAsesoria,
    enviarNotificacionDirectivos
}
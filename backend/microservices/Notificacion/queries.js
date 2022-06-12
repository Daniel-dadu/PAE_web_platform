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

module.exports = {
    get_notificaciones_usuario,
    get_asesoresDisponibles
}
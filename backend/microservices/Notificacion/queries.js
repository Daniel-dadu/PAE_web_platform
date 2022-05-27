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
            throw error
        } else {
            response.status(200).json({'notificaciones': result.rows})
            // console.log(result.rows)
        }
    })

}

module.exports = {
    get_notificaciones_usuario
}
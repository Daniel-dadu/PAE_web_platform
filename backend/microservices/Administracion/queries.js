const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'pae',
  host: 'localhost',
  database: 'pae_db',
  password: 'devsoft_db_manager',
  port: 5432,
})

const getUsersByRol = (request, response) => {

    const rol = request.query.rol

    const consulta = `SELECT "idUsuario" AS matricula, CONCAT("nombreUsuario", ' ', "apellidoPaterno", ' ', "apellidoMaterno") AS nombreCompleto FROM "Usuario" WHERE "rol" = $1`

    pool.query(consulta, [rol], (error, results) => {
        if (error) {
            response.status(400).send("Error: No se pudo obtener la información de los asesores")
        } else {
            response.status(200).json(results.rows)
        }
    })
}

module.exports = {
    getUsersByRol
}
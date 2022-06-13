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

const setNewPeriodos = (request, response) => {
    const periodo1 = request.body.periodo1
    const periodo2 = request.body.periodo2
    const periodo3 = request.body.periodo3

    const params = [periodo1.inicio, periodo1.fin, periodo2.inicio, periodo2.fin, periodo3.inicio, periodo3.fin]
    pool.query(`CALL update_periodos($1,$2,$3,$4,$5,$6)`, params, error => {
        if(error) response.status(400).send("Error: No se pudieron insertar los periodos")
        else response.status(200).send("Se han registrado las nuevas fechas de los periodos correctamente")
    })
}

module.exports = {
    getUsersByRol,
    setNewPeriodos
}
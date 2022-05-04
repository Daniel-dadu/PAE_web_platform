const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'dadu',
  host: 'localhost',
  database: 'apitest',
  password: 'dadu',
  port: 5432,
})

const getUsuarios = (request, response) => {
  pool.query('SELECT * FROM "Usuario"', (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

module.exports = {
  getUsuarios
}
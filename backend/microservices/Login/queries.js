const Pool = require('pg').Pool

const encrypt = require('./encrypt')

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'dadu',
  host: 'localhost',
  database: 'apitest',
  password: 'dadu',
  port: 5432,
})

const validateCredentials = (request, response) => {
    const user = request.params.user
    const pass = request.params.pass

    pool.query('SELECT "password", "salt" FROM "Acceso" WHERE "idUsuario" = $1',[user], (error, res) => {
        if (error) {
            throw error
        }
        // let credentials = json(res.rows)

        response.status(200).json(res.rows)
    })
}

module.exports = {
    validateCredentials
}

/*
passwords:
1. ojito

*/
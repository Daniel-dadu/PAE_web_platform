const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
    user: 'pae',
    host: 'localhost',
    database: 'pae_db',
    password: 'devsoft_db_manager',
    port: 5432,
})

const getMeses_inicio_fin_semestre = (_request, response) => {
    pool.query('SELECT * FROM get_meses_inicio_fin_semestre()', (error, result) => {
        if(error) {
            throw error
        } else {
            response.status(200).json(result.rows[0])
        }
    })
}


module.exports = {
    getMeses_inicio_fin_semestre
}
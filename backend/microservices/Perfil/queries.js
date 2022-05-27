const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
    user: 'pae',
    host: 'localhost',
    database: 'pae_db',
    password: 'devsoft_db_manager',
    port: 5432,
})

const getInfoUser = (request, response) => {
    const user_id = request.query.user
    const user_rol = request.query.rol

    pool.query(`SELECT * FROM get_info_perfil($1, $2)`, [user_id, user_rol], (error, result) => {
        if(error) {
            response.status(400).send("Error: no se pudo obtener la información de ese usuario")
        } else {
            response.status(200).json(result.rows[0])
        }
    })
}

module.exports = {
    getInfoUser
}
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

const updateInfoUser = (request, response) => {
    const user_id = request.body.user
    const user_rol = request.body.rol
    const user_foto = request.body.foto
    const user_telefono = request.body.telefono
    const user_carrera1 = request.body.carrera1
    const user_carrera2 = request.body.carrera2
    const user_semestre = request.body.semestre
    
    const consulta = `CALL update_info_perfil($1, $2, $3, $4, $5, $6, CAST($7 AS SMALLINT))`

    const parameters = [user_id, user_rol, user_foto, user_telefono, user_carrera1, user_carrera2, user_semestre]

    pool.query(consulta, parameters, error => {
        if(error) {
            response.status(400).send("Error: No se pudo actualizar la información del usuario")
        } else {
            response.status(200).send("Se actualizó correctamente la información del usuario")
        }
    })
}

const getFotoUser = (request, response) => {
    const iduser = request.query.iduser

    pool.query('SELECT "fotoPerfil" FROM "Usuario" WHERE "idUsuario" = $1', [iduser], (error, result) => {
        if(error) {
            response.status(400).send("Error: No se pudo obtener la imagen de perfil del usuario")
        } else {
            response.status(200).json(result.rows[0])
        }
    })
}

module.exports = {
    getInfoUser,
    updateInfoUser,
    getFotoUser
}
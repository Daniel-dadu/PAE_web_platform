const Pool = require('pg').Pool

const encrypt = require('../EncryptionFile/encrypt.js')

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
    user: 'pae',
    host: 'localhost',
    database: 'pae_db',
    password: 'devsoft_db_manager',
    port: 5432,
})

const validateCredentials = (request, response) => {
    // Parámetros proporcionados en la request HTTP
    const userID = request.body.user
    const userPass = request.body.password

    // Se hace la consulta de la contraseña y salt que tiene ese "userID"
    pool.query('SELECT "password", "salt" FROM "Acceso" WHERE "idUsuario" = $1',[userID], (error, res) => {
        if (error) {
            throw error
        } else if(!res.rows.length) {
            // En caso de que no se encuentre ningún usuario con ese userID (matrícula), se manda un mensaje de error
            response.status(404).json({"ERROR": "invalid userID"})
        } else {
            // Se usa el dato de la contraseña y string salt de ese usuario
            let password = res.rows[0].password
            let salt = res.rows[0].salt
            
            // Se genera el hash de la contraseña que proporcionó el usuario con su salt
            let userPassHashed = encrypt.getPassword(userPass, salt)

            // Se evalua que la contraseña corresponda a la del usuario
            if(password === userPassHashed) {
                pool.query('SELECT update_ultima_conexion($1)', [userID], (error, res) => {
                    if(error) throw error
                    // Se regresa el tipo de rol del usuario que se ingresó
                    else response.status(200).json({rolUsuario: res.rows[0].update_ultima_conexion})
                })
            } else {
                response.status(404).json({"ERROR": "incorrect password"}) 
            }
    
        }
    })
}

module.exports = {
    validateCredentials
}

/*
passwords:
1. ojito

*/
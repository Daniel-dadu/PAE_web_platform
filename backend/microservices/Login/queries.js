const Pool = require('pg').Pool

const encrypt = require('../EncryptionFile/encrypt.js')

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'dadu',
  host: 'localhost',
  database: 'apitest',
  password: 'dadu',
  port: 5432,
})

const validateCredentials = (request, response) => {
    // Parámetros proporcionados en la request HTTP
    const userID = request.params.user
    const userPass = request.params.pass

    // Se hace la consulta de la contraseña y salt que tiene ese "userID"
    pool.query('SELECT "password", "salt" FROM "Acceso" WHERE "idUsuario" = $1',[userID], (error, res) => {
        if (error) {
            throw error
        } else if(!res.rows.length) {
            // En caso de que no se encuentre ningún usuario con ese userID (matrícula), se manda un mensaje de error
            response.status(404).json({"login-validateCredentials": "invalid userID"})
        } else {
            // Se usa el dato de la contraseña y string salt de ese usuario
            let password = res.rows[0].password
            let salt = res.rows[0].salt
            
            // Se genera el hash de la contraseña que proporcionó el usuario con su salt
            let userPassHashed = encrypt.getPassword(userPass, salt)
    
            // Se evalua que la contraseña corresponda a la del usuario
            response.status(200).json({"login-validateCredentials": (password === userPassHashed) ? "valid" : "invalid password"} )
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
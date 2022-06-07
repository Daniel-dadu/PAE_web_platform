const { request, response } = require('express')

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

const prueba_fotoPerfil = (request, response) => {
    const matricula = request.body.matricula
    const fotoPerfil = request.body.fotoPerfil
  
    pool.query('UPDATE "Usuario" SET "fotoPerfil" = $2 WHERE "idUsuario" = $1', [matricula, fotoPerfil], (error) => {
        if(error){
            throw error
        } else {
            response.status(200).send("La imagen de perfil se actualizó correctamente")
        }
    })
}

const prueba_getfotoPerfil = (request, response) => {
    const matricula = request.query.matricula

    pool.query('SELECT "fotoPerfil" FROM "Usuario" WHERE "idUsuario" = $1', [matricula], (error, result) => {
        if(error){
            throw error
        } else {
            response.status(200).json( result.rows[0] )
        }
    })
}

const politica_vigente = (_request, response) => {
    const consulta = `SELECT "titulo", "descripcion" FROM "Politica" WHERE "status" = 'vigente' AND "fechaUltimoCambio" = (SELECT MAX("fechaUltimoCambio") FROM "Politica");`
    pool.query(consulta, (error, result) => {
        if(error) {
            throw error
        } else {
            response.status(200).json(result.rows[0])
        }
    })
}

const nuevo_asesorado = (request, response) => {
    const matricula = request.body.matricula
    const contrasena = request.body.contrasena
    const nombre = request.body.nombre
    const apellidoPaterno = request.body.apellidoPaterno
    const apellidoMaterno = request.body.apellidoMaterno
    const fotoPerfil = request.body.fotoPerfil
    const telefono = request.body.telefono
    const carrera = request.body.carrera
    
    // Obtenemos el nuevo salt y la contraseña encriptada
    const salt = encrypt.getSalt()
    const password = encrypt.getPassword(contrasena, salt)
    
    const consulta = `CALL registro_asesorado($1, $2, $3, $4, $5, $6, $7, $8, $9);`
    const params = [matricula, password, salt, nombre, apellidoPaterno, apellidoMaterno, fotoPerfil, telefono, carrera]

    pool.query(consulta, params, (error) => {
        if(error) {
            response.status(409).send('La matrícula ya está registrada')
        } else {
            response.status(200).send('Se registró al nuevo usuario (asesorado)')
        }
    })
}

const nuevo_asesor = (request, response) => {
    const matricula = request.body.matricula
    const contrasena = request.body.contrasena
    const nombre = request.body.nombre
    const apellidoPaterno = request.body.apellidoPaterno
    const apellidoMaterno = request.body.apellidoMaterno
    const fotoPerfil = request.body.fotoPerfil
    const telefono = request.body.telefono
    const carrera = request.body.carrera
    const carrera2 = request.body.carrera2

    const horario1 = request.body.horarioPeriodo1
    const horario2 = request.body.horarioPeriodo2
    const horario3 = request.body.horarioPeriodo3

    const rollbackTransaction = () => {
        pool.query('ROLLBACK', error => {
            if(error) 
                response.status(400).send('Error: No se pudo detener la transacción en el proceso de registro. Probablemente se haya registrado parcialmente al asesor')
            else 
                response.status(409).send('Error: No se pudo registrar al asesor, probablemente la matrícula ya está resgitrada (transacción cancelada correctamente)')
        })
    }

    pool.query('BEGIN', error => {
        if(error) rollbackTransaction()
        else {

            // JSON Checklist para ir indicando que se registró correctamente cada parte
            let checklistRegistro = {
                datosPerfil: false,
                horario: false,
                UFs: false
            }

            // Obtenemos el nuevo salt y la contraseña encriptada
            const salt = encrypt.getSalt()
            const password = encrypt.getPassword(contrasena, salt)
            
            const consulta = `CALL registro_datosperfil_asesor($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`
            const params = [matricula, password, salt, nombre, apellidoPaterno, apellidoMaterno, fotoPerfil, telefono, carrera, carrera2]

            pool.query(consulta, params, error => {
                if(error){
                    rollbackTransaction()
                    return
                } else {
                    checklistRegistro.datosPerfil = true
                }
            })

            let periodos

            pool.query(`SELECT "numero", "fechaInicial", "fechaFinal" FROM "Periodo" WHERE "status" = 'actual'`, (error, results) => {
                if(error){
                    rollbackTransaction()
                    return
                } else {
                    periodos = results.rows
                }
            })



        }
    })

}

module.exports = {
    prueba_fotoPerfil,
    prueba_getfotoPerfil,
    politica_vigente,
    nuevo_asesorado
}
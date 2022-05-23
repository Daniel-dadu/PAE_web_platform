const { request, response } = require('express')

const Pool = require('pg').Pool

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
    
    const consulta = `INSERT INTO "Usuario" VALUES ($1, 'asesorado', $2, $3, $4, $5, $6, CURRENT_TIMESTAMP, 'activo');`

    pool.query(consulta, [matricula, nombre, apellidoPaterno, apellidoMaterno, fotoPerfil, telefono], (error, result) => {
        if(error) {
            throw error
        } else {
            response.status(200).send(result.rows[0])
        }
    })
}


module.exports = {
    prueba_fotoPerfil,
    prueba_getfotoPerfil,
    politica_vigente,
    nuevo_asesorado
}
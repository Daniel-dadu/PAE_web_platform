const { request, response } = require('express')

const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'pae',
  host: 'localhost',
  database: 'pae_db',
  password: 'devsoft_db_manager',
  port: 5432
})

const politica_vigente = (_request, response) => {
    const consulta = `SELECT "titulo", "descripcion" FROM "Politica" WHERE "status" = 'vigente' AND "fechaUltimoCambio" = (SELECT MAX("fechaUltimoCambio") FROM "Politica");`
    pool.query(consulta, (error, result) => {
        if(error) {
            throw error
        } else {
            response.status(200).json(result.rows)
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

module.exports = {
    prueba_fotoPerfil,
    prueba_getfotoPerfil,
    politica_vigente,
    nuevo_asesorado
}
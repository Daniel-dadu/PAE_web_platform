const { response } = require('express')

const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'dadu',
  host: 'localhost',
  database: 'apitest',
  password: 'dadu',
  port: 5432,
})

const getCarreras = (_request, response) => {
  pool.query('SELECT * FROM "Carrera"', (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getUF_carreraSemestre = (request, response) => {
  // Parámetros proporcionados en la request HTTP
  const carrera = request.params.carrera
  const semestre = request.params.semestre

  const consulta = 'SELECT "UnidadFormacion"."idUF" AS "claveUF", "nombreUF" FROM "UnidadFormacion", "UnidadFormacionCarrera" WHERE "UnidadFormacionCarrera"."idUF" = "UnidadFormacion"."idUF" AND "UnidadFormacionCarrera"."idCarrera" = $1 AND "UnidadFormacion"."semestre" = $2'

  pool.query(consulta, [carrera, semestre], (error, results) => {
    if (error) {
      throw error
    } else if(!results.rows.length) {
      // En caso de que no se encuentre ninguna UF con ese semestre y carrera
      response.status(404).json({"asesoria-UF_carreraSemestre": "No se encontraron UFs para esa carrera y semestre"})
    } else {
      // Se regresa la lista de las UFs de esa carrera y semestre
      response.status(200).json(results.rows)
    }
  })
}

const setAsesoria = (request, response) => {

  const asesorado = request.params.asesorado
  const uf = request.params.uf

  // Función que se ejecuta en caso de que falle alguna consulta
  const abort = err => {
    if (err) {
      console.error('Error in transaction', err.stack)
      pool.query('ROLLBACK', err => {
        if (err) console.error('Error rolling back client', err.stack)
      })
    }
    return !!err
  }

  // Hacemos la llamada a el procedure new_asesoria para crear la nueva asesoría con los parámetros proporcionados por el usuario
  pool.query('START TRANSACTION', error => {
    if(abort(error)) return // Enters if there was an error with starting the transaction
    
    // Hacemos la llamada al procedure new_asesoria para crear la nueva asesoría con los parámetros proporcionados por el usuario
    pool.query('CALL new_asesoria($1, $2)', [asesorado, uf], (error, results) => {
      if(abort(error)) return

      // Regresamos el idAsesoria en un JSON
      pool.query('SELECT "idAsesoria" FROM "Asesoria" ORDER BY "idAsesoria" DESC LIMIT 1', (error, result) => {
        if(abort(error)) return

        // Guardamos los cambios realizados en la base de datos
        pool.query('COMMIT', err => {
          if(abort(err)) return
        })

        response.status(201).json(result.rows[0])
      })
    })

  })

  // pool.query(consulta, [asesorado, uf], (error, results) => {
  //   if (error) {
  //     throw error
  //   }

  //   console.log(results);

  //   response.status(201).send('New Asesoría correctly created with id')
  // })
}

module.exports = {
  getCarreras,
  getUF_carreraSemestre,
  setAsesoria
}
const { response, request } = require('express')

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
  const carrera = request.body.carrera
  const semestre = request.body.semestre

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


const getDias_uf = (request, response) => {

  const uf = request.body.uf

  // Consulta que regresa los días de asesoría disponibles para cierta materia descartando duplicados y descartando los horarios de disponibilidad pasados
  const consulta = `SELECT DISTINCT("HorarioDisponible"."fechaHora"::date) FROM "AsesorUnidadFormacion", "HorarioDisponiblePeriodo", "HorarioDisponible" WHERE "AsesorUnidadFormacion"."idUsuario" = "HorarioDisponiblePeriodo"."idAsesor" AND "HorarioDisponiblePeriodo"."idHorarioDisponiblePeriodo" = "HorarioDisponible"."idHorarioDisponiblePeriodo" AND "HorarioDisponible"."status" = 'disponible' AND "HorarioDisponible"."fechaHora" > (CURRENT_DATE + INTERVAL '1 day') AND "AsesorUnidadFormacion"."idUF" = $1`

  pool.query(consulta, [uf], (error, results) => {
    if(error){
      throw error
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getHoras_ufDia = (request, response) => {

  const uf = request.body.uf
  const dia = request.body.dia

  // Consulta que regresa las horas disponibles para cierta materia y descartando los horarios de disponibilidad pasados
  const consulta = `SELECT DISTINCT("HorarioDisponible"."fechaHora"::time), "HorarioDisponible"."idHorarioDisponible" FROM "AsesorUnidadFormacion", "HorarioDisponiblePeriodo", "HorarioDisponible" WHERE "AsesorUnidadFormacion"."idUsuario" = "HorarioDisponiblePeriodo"."idAsesor" AND "HorarioDisponiblePeriodo"."idHorarioDisponiblePeriodo" = "HorarioDisponible"."idHorarioDisponiblePeriodo" AND "HorarioDisponible"."status" = 'disponible' AND "AsesorUnidadFormacion"."idUF" = $1 AND "HorarioDisponible"."fechaHora"::date = $2`

  pool.query(consulta, [uf, dia], (error, results) => {
    if(error){
      throw error
    } else {
      response.status(200).json(results.rows)
    }
  })
}


const getInfo_ufFechaHora = (request, response) => {

  const idAsesoria = request.body.idAsesoria

  const consulta = `SELECT "UnidadFormacion"."idUF", "UnidadFormacion"."nombreUF", "HorarioDisponible"."fechaHora"::date AS fecha, "HorarioDisponible"."fechaHora"::time AS hora FROM "Asesoria", "UnidadFormacion", "HorarioDisponible" WHERE "Asesoria"."idUF" = "UnidadFormacion"."idUF" AND "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible" AND "Asesoria"."idAsesoria" = $1`

  pool.query(consulta, [idAsesoria], (error, result) => {
    if(error){
      throw error
    } else {
      response.status(200).json(result.rows[0])
    }
  })
}


const createAsesoria = (request, response) => {

  const asesorado = request.body.asesorado
  const uf = request.body.uf

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

  // Iniciamos la transacción
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
}


const setAsesoria_updateDuda = (request, response) => {
  const idAsesoria = request.body.idAsesoria
  const duda = request.body.duda
  const imagenes = request.body.imagenes

  const consultas = [
    'UPDATE "Asesoria" SET "descripcionDuda" = $1 WHERE "idAsesoria" = $2',
    'INSERT INTO "AsesoriaImagen" VALUES ($1, $2)'
  ]

  // Se ejecuta la primera consulta, la cual actualiza la descripción de la duda
  pool.query(consultas[0], [duda, idAsesoria], error => {
    if (error) {
      throw error
    } else {
      // Se itera por el array de imagenes que se recibe y se insertan todas
      imagenes.map(imagen => {
        pool.query(consultas[1], [idAsesoria, imagen], error => {
          if (error) {
            throw error
          }
        })
      })
  
      response.status(200).send('Duda e imagenes insertadas en la asesoría con ID:' + idAsesoria)
    }
  })
}


const setAsesoria_updateFechaHora = (request, response) => {
  const idAsesoria = request.body.idAsesoria
  const idHorarioDisponible = request.body.idHorarioDisponible

  const consulta = 'UPDATE "Asesoria" SET "idHorarioDisponible" = $1 WHERE "idAsesoria" = $2'

  pool.query(consulta, [idHorarioDisponible, idAsesoria], error => {
    if(error) throw error

    response.status(200).send('Horario disponible insertado en la asesoría con ID:' + idAsesoria)
  })
}


const setAsesoria_reservarHorario = (request, response) => {
  const idHorarioDisponible = request.body.idHorarioDisponible

  const consulta = `UPDATE "HorarioDisponible" SET "status" = 'reservada' WHERE "idHorarioDisponible" = $1`

  pool.query(consulta, [idHorarioDisponible], error => {
    if(error) throw error

    response.status(200).send(`Status cambiado a reservada en horario disponible con id ${idHorarioDisponible}`)
  })
}


const deleteAsesoria = (request, response) => {
  const idAsesoria = request.body.idAsesoria

  const consulta = 'DELETE FROM "Asesoria" WHERE "idAsesoria" = $1'

  pool.query(consulta, [idAsesoria], error => {
    if(error) throw error

    response.status(200).send(`Asesoria con id ${idAsesoria} correctamente ELIMINADA`)
  })
}

module.exports = {
  getCarreras,
  getUF_carreraSemestre,
  getDias_uf,
  getHoras_ufDia,
  getInfo_ufFechaHora,
  createAsesoria,
  setAsesoria_updateDuda,
  setAsesoria_updateFechaHora,
  setAsesoria_reservarHorario,
  deleteAsesoria
}
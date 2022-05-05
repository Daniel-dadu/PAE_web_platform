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

module.exports = {
  getCarreras,
  getUF_carreraSemestre
}
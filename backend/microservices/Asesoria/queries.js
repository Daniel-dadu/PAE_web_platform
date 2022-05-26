const { response, request } = require('express')

const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
  user: 'pae',
  host: 'localhost',
  database: 'pae_db',
  password: 'devsoft_db_manager',
  port: 5432,
})

const getUF_carreraSemestre = (request, response) => {
  // Parámetros proporcionados en la request HTTP
  const carrera = request.query.carrera
  const semestre = request.query.semestre

  if(carrera === "null" || semestre === "null") {
    response.status(400).json([])
    return
  }

  const consulta = 'SELECT "UnidadFormacion"."idUF" AS "claveUF", "nombreUF" FROM "UnidadFormacion", "UnidadFormacionCarrera" WHERE "UnidadFormacionCarrera"."idUF" = "UnidadFormacion"."idUF" AND "UnidadFormacionCarrera"."idCarrera" = $1 AND "UnidadFormacion"."semestre" = $2'

  pool.query(consulta, [carrera, semestre], (error, results) => {
    if (error) {
      throw error
    } else if(!results.rows.length) {
      // En caso de que no se encuentre ninguna UF con ese semestre y carrera
      response.status(404).json({"ERROR": "No se encontraron UFs para esa carrera y semestre"})
    } else {
      // Se regresa la lista de las UFs de esa carrera y semestre
      response.status(200).json(results.rows)
    }
  })
}


const getDiasDisponibles = (request, response) => {

  const uf = request.query.uf
  const anio = parseInt(request.query.anio)
  const mes = parseInt(request.query.mes)

  // Función para obtener el nombre del mes a partir del número
  const getMonthEspanol = mesEnNumero => 
    mesEnNumero === 1 ? 'Enero' : 
    mesEnNumero === 2 ? 'Febrero' : 
    mesEnNumero === 3 ? 'Marzo' : 
    mesEnNumero === 4 ? 'Abril' :
    mesEnNumero === 5 ? 'Mayo' :
    mesEnNumero === 6 ? 'Junio' :
    mesEnNumero === 7 ? 'Julio' :
    mesEnNumero === 8 ? 'Agosto' :
    mesEnNumero === 9 ? 'Septiembre' :
    mesEnNumero === 10 ? 'Octubre' :
    mesEnNumero === 11 ? 'Noviembre' : 'Diciembre'

  pool.query(`SELECT * FROM get_dias_disponibles($1, $2, $3)`, [uf, anio, mes], (error, results) => {
    if(error){
      throw error
    } else {
      response.status(200).json({ [getMonthEspanol(mes)]: results.rows.map(object => object.dias_disponibles) })
    }
  })

}

const getHorasDisponibles = (request, response) => {

  const uf = request.query.uf
  const anio = request.query.anio
  const mes = request.query.mes
  const dia = request.query.dia

  // Consulta que regresa las horas disponibles para cierta materia y descartando los horarios de disponibilidad pasados
  const consulta = `SELECT * FROM get_horas_disponibles($1, $2, $3, $4);`

  pool.query(consulta, [uf, anio, mes, dia], (error, results) => {
    if(error){
      throw error
    } else {
      response.status(200).json({horas_disponibles: results.rows.map(object => object.horas_disponibles)})
    }
  })
}

const createAsesoria = (request, response) => {

  const uf = request.body.uf
  const anio = request.body.anio
  const mes = request.body.mes
  const dia = request.body.dia
  const hora = request.body.hora
  const duda = request.body.duda
  const asesorado = request.body.asesorado

  const consulta1 = `SELECT * FROM verificar_horarios_disponibles($1, $2, $3, $4, $5)`

  pool.query(consulta1, [uf, anio, mes, dia, hora], (error, result) => {
    if (error) {
      response.status(409).send("Error: El horario ya ha sido reservado")
    } else {

      const idHorario = result.rows[0].idhorariodisponible
      const consulta2 = `SELECT * FROM nueva_asesoria($1, $2, $3, $4, $5, $6, $7, $8)`

      pool.query(consulta2, [uf, anio, mes, dia, hora, asesorado, idHorario, duda], (error, results) => {
        if(error){
          response.status(404).send("Error: No se pudo agendar la asesoría")
        } else {
          response.status(200).json({ idAsesoria: results.rows[0].nueva_asesoria })
        }
      })

    }
  })

}

const insertImagen = (request, response) => {
  const idAsesoria = request.body.idAsesoria
  const imagen = request.body.imagen

  const consulta = 'INSERT INTO "AsesoriaImagen" ("idAsesoria", "imagen") VALUES ($1, $2)'
  
  pool.query(consulta, [idAsesoria, imagen], (error) => {
    if(error) {
      response.status(400).send("Error: No se pudo insertar la imagen")
    } else {
      response.status(200).send("Se insertó la imagen correctamente")
    }
  })
}


module.exports = {
  getCarreras,
  getUF_carreraSemestre,
  getDiasDisponibles,
  getHorasDisponibles,
  createAsesoria,
  insertImagen
}
const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
    user: 'pae',
    host: 'localhost',
    database: 'pae_db',
    password: 'devsoft_db_manager',
    port: 5432,
})

const getCarreras = (_request, response) => {
    pool.query('SELECT * FROM "Carrera"', (error, results) => {
        if (error) {
            response.status(400).send("Error: no se pudieron obtener las carreras de la base de datos")
        } else {
            response.status(200).json(results.rows)
        }
    })
}  

const getMeses_inicio_fin_semestre = (_request, response) => {
    pool.query('SELECT * FROM get_meses_inicio_fin_semestre()', (error, result) => {
        if(error) {
            response.status(400).send("Error: no se pudo acceder a la información")
        } else {
            response.status(200).json(result.rows[0])
        }
    })
}

const getNombreUF = (request, response) => {
    const idUF = request.query.id_uf

    pool.query(`SELECT "nombreUF" FROM "UnidadFormacion" WHERE "idUF" = $1`, [idUF], (error, result) => {
        if(error) {
            response.status(400).send("Error: no se pudo acceder a la información")
        } else {
            response.status(200).json(result.rows[0])
        }
    })
}

const getUFs_fromCarreras = (request, response) => {
    const carrera1 = request.query.carrera1
    const carrera2 = request.query.carrera2

    const consulta = `SELECT DISTINCT "UnidadFormacion"."idUF", "nombreUF", "semestre" FROM "UnidadFormacionCarrera" INNER JOIN "UnidadFormacion" ON "UnidadFormacionCarrera"."idUF" = "UnidadFormacion"."idUF" WHERE "UnidadFormacionCarrera"."idCarrera" = $1 OR "UnidadFormacionCarrera"."idCarrera" = $2`

    pool.query(consulta, [carrera1, carrera2], (error, result) => {
        if(error) {
            response.status(400).send("Error: no se encontraron UFs para esa(s) carrera(s)")
        } else {

            let planEstudios = [1,2,3,4,5,6,7,8,9].map(i => ({semestre: i, unidadesFormacion: []}))

            result.rows.forEach(UFjson => {
                planEstudios[UFjson.semestre - 1].unidadesFormacion.push({
                    claveUF: UFjson.idUF,
                    nombreUF: UFjson.nombreUF
                })
            })
            
            response.status(200).json(planEstudios)
        } 
    })
}


module.exports = {
    getCarreras,
    getMeses_inicio_fin_semestre,
    getNombreUF,
    getUFs_fromCarreras
}
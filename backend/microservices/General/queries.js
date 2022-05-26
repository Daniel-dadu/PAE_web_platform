const Pool = require('pg').Pool

// IMPORTANTE: Estas credenciales de Postgres no deben estar aquí, solo es para probar
const pool = new Pool({
    user: 'pae',
    host: 'localhost',
    database: 'pae_db',
    password: 'devsoft_db_manager',
    port: 5432,
})

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


module.exports = {
    getMeses_inicio_fin_semestre,
    getNombreUF
}
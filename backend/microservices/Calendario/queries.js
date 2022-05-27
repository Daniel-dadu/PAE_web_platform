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

const get_asesorias_usuario = (request, response) => {
    
    const id = request.query.idUsuario
    const mes = request.query.mes
    const anio = request.query.anio

    if(id === "null" || mes === "null" || anio === "null") {
        response.status(400).json([])
        return
    }

    const consulta = `SELECT * FROM get_asesorias_usuario($1, $2, $3);` // SELECT * FROM get_notificaciones_usuario('A01657967');

    pool.query(consulta, [id, mes, anio], (error, result) => {
        if(error) {
            throw error
        } else {
            
            // response.status(200).json({'dias': result.rows})
            // console.log({'dias': result.rows})
            
            // const output = [{'dias': result.rows}];
            const output = result.rows;
            
            // Accepts the array and key
            const groupBy = (array, key) => {
                // Return the end result
                return array.reduce((result, currentValue) => {
                    // If an array already present for key, push it to the array. Else create an array and push the object
                    (result[currentValue[key]] = result[currentValue[key]] || {
                        'asesorias': []
                    })['asesorias'].push({
                        'status': currentValue['status'],
                        'hora': currentValue['hora'],
                        'openPanel': `() => {toggle()}`
                        // 'openPanel': `() => {toggle(${currentValue['numerodia']}, ${mes}, ${anio})}`
                    });
                    // Return the current iteration `result` value, this will be taken as next iteration `result` value and accumulate
                    return result;
                }, {}); // empty object is the initial value for result object
            };
            
            // Group by color as key to the person array
            const personGroupedByColor = groupBy(output, 'numerodia');
            response.status(200).json(personGroupedByColor)

        }
    })

}

const get_allAsesorias = (request, response) => {

    const mes = request.query.mes
    const anio = request.query.anio

    if(mes === "null" || anio === "null") {
        response.status(400).json([])
        return
    }

    const consulta = `SELECT * FROM get_allAsesorias($1, $2);` // SELECT * FROM get_notificaciones_usuario('A01657967');

    pool.query(consulta, [mes, anio], (error, result) => {
        if(error) {
            throw error
        } else {
            
            // response.status(200).json({'dias': result.rows})
            // console.log({'dias': result.rows})
            
            // const output = [{'dias': result.rows}];
            const output = result.rows;
            
            // Accepts the array and key
            const groupBy = (array, key) => {
                // Return the end result
                return array.reduce((result, currentValue) => {
                    // If an array already present for key, push it to the array. Else create an array and push the object
                    (result[currentValue[key]] = result[currentValue[key]] || {
                        'asesorias': []
                    })['asesorias'].push({
                        'status': currentValue['status'],
                        'hora': currentValue['hora']
                    });
                    // Return the current iteration `result` value, this will be taken as next iteration `result` value and accumulate
                    return result;
                }, {}); // empty object is the initial value for result object
            };
            
            // Group by color as key to the person array
            const personGroupedByColor = groupBy(output, 'numerodia');
            response.status(200).json(personGroupedByColor)

        }
    })

}

module.exports = {
    get_asesorias_usuario,
    get_allAsesorias
}
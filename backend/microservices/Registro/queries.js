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
    const semestre = request.body.semestre

    const horario1 = request.body.horarioPeriodo1
    const horario2 = request.body.horarioPeriodo2
    const horario3 = request.body.horarioPeriodo3

    const ufs = request.body.ufs

    // Se pone un punto y coma antes para no tomar lo anterior como una función 
    ;(async () => {

        const client = await pool.connect()

        try {

            // ================= INICIO TRANSACCION ================= //
            await client.query('BEGIN')
            // ================= INICIO TRANSACCION ================= //

            ///////////////////////////////////////////////
            //////// Registro de Datos personales /////////

            // Obtenemos el nuevo salt y la contraseña encriptada
            const salt = encrypt.getSalt()
            const password = encrypt.getPassword(contrasena, salt)
            
            const consulta = `CALL registro_datosperfil_asesor($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)`
            const params = [matricula, password, salt, nombre, apellidoPaterno, apellidoMaterno, fotoPerfil, telefono, carrera, carrera2, semestre]

            await client.query(consulta, params)

            ///// Fin de registro de datos personales /////
            ///////////////////////////////////////////////


            ///////////////////////////////////////////////
            ///////////// Registro de Horario /////////////
            let holyWeekStartDates = {
                2022: new Date('11 April 2022'),
                2023: new Date('3 April 2023'),
                2024: new Date('25 March 2024'),
                2025: new Date('14 April 2025'),
                2026: new Date('30 March 2026'),
                2027: new Date('22 March 2027'),
                2028: new Date('10 April 2028'),
                2029: new Date('26 March 2029'),
                2030: new Date('15 April 2030')
            }

            const periodosData = await client.query(`SELECT "idPeriodo", "numero", "fechaInicial", "fechaFinal" FROM "Periodo" WHERE "status" = 'actual' ORDER BY "numero"`)
            let periodos = periodosData.rows

            periodos[0].horario = JSON.parse(horario1)
            periodos[1].horario = JSON.parse(horario2)
            periodos[2].horario = JSON.parse(horario3)

            const currentHWStartDate = holyWeekStartDates[periodos[0].fechaInicial.getFullYear()]

            periodos.forEach(async periodo => {

                const consultaHorarioDP = `INSERT INTO "HorarioDisponiblePeriodo" ("idHorarioDisponiblePeriodo", "idAsesor", "idPeriodo") VALUES (DEFAULT, $1, $2) RETURNING "idHorarioDisponiblePeriodo"`

                const getHorarioDP = await client.query(consultaHorarioDP, [matricula, periodo.idPeriodo])

                let NEWidHorarioDisponiblePeriodo = getHorarioDP.rows[0].idHorarioDisponiblePeriodo

                const periodoStartDate = periodo.fechaInicial

                // console.log('\n\n ========= Periodo =========', periodo.numero)
                // console.log('Fecha inicial', periodo.fechaInicial)

                const dias = [['lunes',0], ['martes',1], ['miercoles',2], ['jueves',3], ['viernes',4]]
                
                dias.forEach(async dia => {
                    
                    let currentInsertDate = new Date(periodoStartDate)
                    currentInsertDate.setDate(currentInsertDate.getDate() + dia[1])
                    const currentSpecificDate = new Date(currentInsertDate)

                    // console.log("\n > Dia", dia[0])
                    
                    let horasArray = periodo.horario[dia[0]]
                    
                    // Recorremos cada una de las horas de cierto día de la semana
                    for (let i = 0; i < horasArray.length; i++) {
                        currentInsertDate = new Date(currentSpecificDate)

                        // console.log("currentSpecificDate", currentSpecificDate)

                        currentInsertDate.setHours(horasArray[i])
                        // console.log("Hora", horasArray[i])

                        for (let index = 0; index < 5; index++) {
                            // Si la fecha está dentro de semana santa, se aumenta una semana
                            if(currentInsertDate >= currentHWStartDate && 
                                currentInsertDate < new Date(currentHWStartDate.getFullYear(), currentHWStartDate.getMonth(), currentHWStartDate.getDate()+6)) 
                            {
                                currentInsertDate.setDate(currentInsertDate.getDate() + 7)
                            }
                            // console.log("Date inserted", currentInsertDate)
                            const consultaHorarioDispo = `INSERT INTO "HorarioDisponible" ("idHorarioDisponible", "idHorarioDisponiblePeriodo", "fechaHora", "status") VALUES (DEFAULT, $1, $2, 'disponible')`
        
                            await client.query(consultaHorarioDispo, [NEWidHorarioDisponiblePeriodo, currentInsertDate])
                            currentInsertDate.setDate(currentInsertDate.getDate() + 7)
                        }
                        
                    }
                    
                })

            })

            ////////// Fin de Registro de Horario /////////
            ///////////////////////////////////////////////


            ///////////////////////////////////////////////
            /////////////// Registro de UFs ///////////////
            ufs.forEach(async claveUF => {
                await client.query(`INSERT INTO "AsesorUnidadFormacion" ("idUsuario","idUF") VALUES ($1, $2)`, [matricula, claveUF])
            })
            /////////// Fin de Registro de UFs ////////////
            ///////////////////////////////////////////////
                        
            // ================= FIN TRANSACCION ================= //
            await client.query('COMMIT')
            response.status(200).send('Se registró al asesor correctamente')
            // ================= FIN TRANSACCION ================= //

        } catch (e) {
            await client.query('ROLLBACK')
            throw e
            
        } finally {
            client.release()
        }

    })().catch(_e => 
        response.status(409).send('Error: No se pudo registrar al asesor, probablemente la matrícula ya está resgitrada (transacción cancelada correctamente)')
    )

}

module.exports = {
    prueba_fotoPerfil,
    prueba_getfotoPerfil,
    politica_vigente,
    nuevo_asesorado,
    nuevo_asesor
}
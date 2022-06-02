import React, { useState, useEffect, useCallback } from 'react'
import './CalendarioDisponibilidad.css'

/*
previousHorario:
{
    lunes: [],
    martes: [],
    miercoles: [],
    jueves: [],
    viernes: [],
    total: 0
}
*/

const CalendarioDisponibilidad = ({ parentCallback, previousHorario }) => {

    const [horario, setHorario] = useState(previousHorario)

    const onSelectHorario = idHorario => {

        let nuevoHorario = horario
        const horaInt = idHorario.length < 4 ? parseInt(idHorario[2]) : parseInt(idHorario.substring(2,4))
        
        const updateNewHorario = (dia) => { 
            const indexHora = nuevoHorario[dia].indexOf(horaInt)
            if (indexHora === -1) {
                nuevoHorario[dia].push(horaInt)
                nuevoHorario.total++
            } else {
                nuevoHorario[dia].splice(indexHora, 1)
                nuevoHorario.total--
            }
        }

        updateNewHorario(
            idHorario[0] === '0' ? 'lunes' : 
            idHorario[0] === '1' ? 'martes' : 
            idHorario[0] === '2' ? 'miercoles' : 
            idHorario[0] === '3' ? 'jueves' : 'viernes'
        )

        setHorario(nuevoHorario)
    }

    const colorVerification = useCallback((hora, dia) => 
        dia === 0 ? (horario.lunes.indexOf(hora) !== -1 ? '#B1FF96' : '#C4C4C4') :
        dia === 1 ? (horario.martes.indexOf(hora) !== -1 ? '#B1FF96' : '#C4C4C4') :
        dia === 2 ? (horario.miercoles.indexOf(hora) !== -1 ? '#B1FF96' : '#C4C4C4') :
        dia === 3 ? (horario.jueves.indexOf(hora) !== -1 ? '#B1FF96' : '#C4C4C4') :
        (horario.viernes.indexOf(hora) !== -1 ? '#B1FF96' : '#C4C4C4')
    , [horario])
    

    const horas = [8,9,10,11,12,13,14,15,16,17,18,19]
    const numsDiasSemana = [0,1,2,3,4]

    const createMatrixColors = () => 
        horas.map(hora => 
            numsDiasSemana.map(dia => 
                colorVerification(hora, dia)
            )
        )

    const [colors, setColors] = useState(createMatrixColors())

    const selectHour = id => {
        onSelectHorario(id)
        setColors(createMatrixColors())
        parentCallback(horario)
    }

    useEffect(() => {
        setHorario(previousHorario)
    }, [previousHorario])

    useEffect(() => {
        setColors(
            [8,9,10,11,12,13,14,15,16,17,18,19].map(hora => 
                [0,1,2,3,4].map(dia => 
                    colorVerification(hora, dia)
                )
            )
        )
    }, [horario, colorVerification])

    return(
        <table className = {`calendarioDisponibilidad`} >
            <tbody>
                <tr>
                    <th className = 'nombreDiaCalendarioDisponibilidad' />
                    <th className = 'nombreDiaCalendarioDisponibilidad'> Lunes </th>
                    <th className = 'nombreDiaCalendarioDisponibilidad'> Martes </th>
                    <th className = 'nombreDiaCalendarioDisponibilidad'> Miércoles </th>
                    <th className = 'nombreDiaCalendarioDisponibilidad'> Jueves </th>
                    <th className = 'nombreDiaCalendarioDisponibilidad'> Viernes </th>
                </tr>

                {
                    horas.map((horaElement, index) => 
                        <tr key={index}>

                            <td className = 'bloqueCalendarioDisponibilidad'>
                                <div className = 'horaCalendarioDisponibilidad'>
                                    <p className = 'txtHoraCalendarioDisponibilidad'> {horaElement}:00 </p>
                                </div>
                            </td>

                            { 
                                numsDiasSemana.map(i => 
                                    <td className = 'bloqueCalendarioDisponibilidad' key={i} >
                                        <div 
                                            className = 'seleccionCalendario' 
                                            onClick = {() => selectHour(`${i}-${horaElement}`)} 
                                            id = {`${i}-${horaElement}`} 
                                            style={{backgroundColor: colors[horaElement-8][i] }}
                                        />
                                    </td>
                                )
                            }

                        </tr>
                    )
                }
            </tbody>
        </table>
    );

};

export default CalendarioDisponibilidad
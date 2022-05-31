import React from 'react'
import './CalendarioDisponibilidad.css'

const CalendarioDisponibilidad = ({ parentCallback }) => {

    const selectHour = id => {
        
        parentCallback(id)

        let hour = document.getElementById(id);
    
        if(window.getComputedStyle(hour).backgroundColor === 'rgb(196, 196, 196)'){
            hour.style.backgroundColor = '#B1FF96';
        } else {
            hour.style.backgroundColor = '#C4C4C4';
        }
    }

    const horas = [8,9,10,11,12,13,14,15,16,17,18,19]

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
                                [0,1,2,3,4].map(i => 
                                    <td className = 'bloqueCalendarioDisponibilidad' key={i} >
                                        <div 
                                            className = 'seleccionCalendario' 
                                            onClick = {() => selectHour(`${i}-${horaElement}`)} 
                                            id = {`${i}-${horaElement}`} 
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
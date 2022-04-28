import React from 'react'
import "./SeleccionarHorarioAsesoria.css"

function SeleccionarHorarioAsesoria(props){
    return(
        <div className='seleccionar_horario_asesoria_container'>
            <div className='seleccionar_horario_asesoria_day'>
                {props.date.day}
            </div>
            <div className='seleccionar_horario_asesoria_info'>
                Selecciona uno de los horarios disponibles:
            </div>
            <div className='seleccionar_horario_asesoria_hours'>
                {props.date.hours.map((hour) => {
                    return (
                        <div className='seleccionar_horario_asesoria_hour_container'>
                            <div className='seleccionar_horario_asesoria_hour_button_container'>
                                <button className='seleccionar_horario_asesoria_hour_button'>{hour}</button>
                            </div>
                        </div>
                    )
                })}
            </div>
        </div>
    )   
}
export default SeleccionarHorarioAsesoria
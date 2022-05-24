import React, {useState} from 'react'
import "./SeleccionarHorarioAsesoria.css"

/*
El componente recibe 1 solo valor de tipo json con las horas de 
disponibilidad para asesoria de un dia, esta conformado por:
   -day: el dia al cual pertenece los datos.
   -hours: es un array con las horas disponibles.

       Ejemplo:
           {
               "day" : "17 de marzo",
               "hours" : [
                   "8:00",
                   ...
               ]
           }

Ejemplo:
   date={info}
*/
function SeleccionarHorarioAsesoria({ date, parentCallback }){

    const [hourSelected, setHourSelected] = useState(localStorage.asesoria_hora ? localStorage.asesoria_hora : null)

    const onSelectHour = (hour) => parentCallback(hour)
   
    return(
        <div className='seleccionar_horario_asesoria_container'>
            <div className='seleccionar_horario_asesoria_day'>
                {date.day}
            </div>
            <div className='seleccionar_horario_asesoria_info'>
                Selecciona uno de los horarios disponibles:
            </div>
            <div className='seleccionar_horario_asesoria_hours'>
                {date.hours.map((hour, index) => {
                    return (
                        <div className='seleccionar_horario_asesoria_hour_container' key={index}>
                            <div className='seleccionar_horario_asesoria_hour_button_container'>
                                <button 
                                className='seleccionar_horario_asesoria_hour_button' 
                                onClick={() => { onSelectHour(hour); setHourSelected(hour); }}
                                style={{backgroundColor: hourSelected === hour ? '#4ce600' : '#CFCFCF'}}>
                                    {hour}
                                </button>
                            </div>
                        </div>
                    )
                })}
            </div>
        </div>
    )   
}
export default SeleccionarHorarioAsesoria
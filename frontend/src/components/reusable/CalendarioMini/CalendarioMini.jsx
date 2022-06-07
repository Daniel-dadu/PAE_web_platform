import React , {useState, useEffect} from 'react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import "./CalendarioMini.css"

import { BsArrowLeftCircle, BsArrowRightCircle } from 'react-icons/bs'

function makeCalendarioMini(calendar, year, monthIndex){
    //Almacena todas la semanas del mes en forma de arreglos de dias.    
    let  weeks = [[]];
    const enabledDays = calendar[Object.keys(calendar)[0]];

    //Obtiene el ultimo dia del mes anterior
    let lastMontLastDay = new Date(year, monthIndex, 0); 
    //En caso de que el mes anterior haya acabado el la misma semana que el 
    //comienzo del mes agrega los ultimos dias corrrespondiante a la primera semana.
    if(lastMontLastDay.getDay() < 6){
        for(let i = lastMontLastDay.getDate() - lastMontLastDay.getDay(); i <= lastMontLastDay.getDate(); i++){
            weeks[0].push({"day": i, "color": "#CFCFCF"})
        }
    }

    //Obtiene el ultimo dia del mes actual
    let currentMontLastDay = new Date(year, monthIndex + 1, 0);
    //Agrega los dial del mes al calendario del mes
    for(let i = 1; i <= currentMontLastDay.getDate(); i++){
        let day = {"day": i, "color": "black"};
        for(let j = 0; j < enabledDays.length; j++){
            if(i === enabledDays[j]){
                day = {"day": i, "color": "#46CF16"};
                break;
            }
        }
        weeks[weeks.length-1].push(day)
        if((new Date(year, monthIndex, i).getDay() === 6) && i !== currentMontLastDay.getDate()){
            weeks.push([])
        }
    }

    //Agrega lo primeros dias del proximo mes que estan presente en la ultima semana
    if(currentMontLastDay.getDay() < 6){
        for(let i = 1; i < 7 - currentMontLastDay.getDay(); i++){
            weeks[weeks.length-1].push({"day": i ,"color": "#CFCFCF"})
        }
    }

    return(
        weeks.map((week, i) =>{
            return(
                <tr key={i}>
                    {week.map((day, index) => {
                        return(
                            <td 
                            className='calendario_mini_day' 
                            style={{color: day.color}} 
                            key={index} > 
                                {   // Si el color es verde, lo convertimos en un link que redirige al usuario al horario de ese día
                                    day.color === "#46CF16" ?
                                    <a href={`./agendarAsesoriaHora/${year}/${monthIndex+1}/${day.day}`} > {day.day} </a> :
                                    <span> {day.day} </span>
                                }
                            </td>
                        )
                    })}
                </tr>
            )
        })
    )
}


/*
El componente recibe 3 valores.
    -enabledDays: un json con el nombre del mes correspodiante al index como llave, y una lista de los dias habiles.
    Ejemplo: { "Abril": [1, 2, 3, 5, 20, 21, 30, 31] }
    -year: el año actual.
    -montIndex: El mes que se desea mostrar, por defecto es 0, y no puede ser negativo.
    -minMonth: El primer mes que debe mostrar el minicalendario
    -maxMonth: El ultimo mes que debe mostrar el minicalendario

Ejemplo:
    enabledDays={info} year="2022" monthIndex={3} minMonth={0} maxMonth={4}
*/
function CalendarioMini(){

    const navigate = useNavigate()

    useEffect(() => {
        // Si no se seleccionó una asesoría, se redirecciona al usuario a la primera pantalla
        if(!localStorage.asesoria_uf) {
            navigate('/agendarAsesoriaUF/error')
            return
        }
    }, [navigate])
    
    // Obtenemos la fecha hoy
    const today = new Date()

    // Obtenemos el año actual
    const year = today.getFullYear() 

    // Usamos un hook para el mes que debe mostrar el calendario, que por defecto es el actual
    // Al mes por defecto se le suma 1 para obtener el valor exacto, respetando el orden de Enero: 1, Febrero: 2 ...
    const [month, setMonth] = useState(today.getMonth()+1)

    // Declaramos el mes mínimo y mes máximo que puede mostrar el calendario
    // Estos corresponden al primer y último mes del semestre actual
    const [minMonth, setMinMonth] = useState(0)
    const [maxMonth, setMaxMonth] = useState(0)

    useEffect(() => {
        // Se establecen los parámetros de la request a la API
        const config = {
            method: 'get',
            url: `http://20.225.209.57:3091/general/meses_inicio_fin_semestre`,
            headers: { }
        }
        
        // Se hace la request y, si es exitosa, se actualizan las variables con sus hooks
        axios(config)
        .then(response => {
            // Se guarda la respuesta de la API, que es un objeto con los meses 
            const mesesInicioFinSemestre = response.data // Ejemplo: {"mes_inicio_semestre":2,"mes_fin_semestre":6}

            // Se redefine el primer y último mes del semestre actual
            setMinMonth(mesesInicioFinSemestre.mes_inicio_semestre)
            setMaxMonth(mesesInicioFinSemestre.mes_fin_semestre)
        })
        .catch(_error => {
            navigate('/agendarAsesoriaUF/error')
            return
        })
    }, [setMinMonth, setMaxMonth, navigate])

    // Variable en la que se guarda la respuesta de la API con el nombre del mes y el array de días disponibles
    const [enabledDays, setEnabledDays] = useState({'Cargando': []})

    // Variable que guarda el código HTML del calendario que regresa la función makeCalendarioMini
    const [miniCalendario, setMiniCalendario] = useState(makeCalendarioMini(enabledDays, year, month));

    // Variable que guarda el nombre del mes en string, el cual obtiene de enabledDays
    const [monthName, setMonthName] = useState(Object.keys(enabledDays));

    // Es hook se ejecuta por defecto siempre que se modifique alguno de los valores en sus dependencias
    // En este caso, cuando se cambia el valor del month, se hace la ejecución de la función de adentro
    useEffect(() => {  

        // Se establecen los parámetros de la request a la API
        const config = {
            method: 'get',
            url: `http://20.225.209.57:3094/asesoria/get_dias/?uf=${localStorage.asesoria_uf}&anio=${year}&mes=${month}`,
            headers: { }
        }
        
        // Se hace la request y, si es exitosa, se actualizan las variables con sus hooks
        axios(config)
        .then(response => {
            // Se guarda la respuesta de la API, que es un objeto con el nombre del mes y días disponibles de ese mes 
            const diasDisponibles = response.data // Ejemplo: {'Mayo': [1,4,6,8]}
            // Se actualizan los días disponibles
            setEnabledDays(diasDisponibles);
            // Se obtiene el nombre del mes y se actualiza
            setMonthName(Object.keys(diasDisponibles))
            // Se vuelve a generar el mini calendario con la función makeCalendarioMini y los nuevos días disponibles
            setMiniCalendario(makeCalendarioMini(diasDisponibles, year, month-1));
        })
        .catch(_error => {
            navigate('/agendarAsesoriaUF/error')
            return
        })

    }, [year, month, setEnabledDays, setMonthName, setMiniCalendario, navigate])

    const goLastMonth = () => {
        if(month > minMonth) setMonth(month - 1)
    }

    const goNextMonth = () => {
        if(month < maxMonth) setMonth(month + 1)
    }

    return(
        <div className='calendario_mini_container'>
            <div className='calendario_mini_top'>
                <button type="button" className='buttonArrow' onClick={goLastMonth}>
                    <BsArrowLeftCircle size={20} className='arrow_calendarioMini' />
                </button>
                <span className='title_mes_anio'>{monthName} {year}</span>
                <button type="button" className='buttonArrow' onClick={goNextMonth}>
                    <BsArrowRightCircle size={20} className='arrow_calendarioMini' />
                </button>
            </div>
            <table className='calendario_mini_month'>
                <tbody>
                    <tr>
                        <th className='calendario_mini_week_day'>Domingo</th>
                        <th className='calendario_mini_week_day'>Lunes</th>
                        <th className='calendario_mini_week_day'>Martes</th>
                        <th className='calendario_mini_week_day'>Miercoles</th>
                        <th className='calendario_mini_week_day'>Jueves</th>
                        <th className='calendario_mini_week_day'>Viernes</th>
                        <th className='calendario_mini_week_day'>Sabado</th>
                    </tr>
                    {miniCalendario}
                </tbody>
            </table>
        </div>
    )   
}
export default CalendarioMini
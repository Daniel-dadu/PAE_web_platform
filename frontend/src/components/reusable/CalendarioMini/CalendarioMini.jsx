import React , {useState, useEffect} from 'react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import "./CalendarioMini.css"

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
            weeks[0].push({"day": i, "color": "grey"})
        }
    }

    //Obtiene el ultimo dia del mes actual
    let currentMontLastDay = new Date(year, monthIndex + 1, 0);
    //Agrega los dial del mes al calendario del mes
    for(let i = 1; i <= currentMontLastDay.getDate(); i++){
        let day = {"day": i, "color": "black"};
        for(let j = 0; j < enabledDays.length; j++){
            if(i === enabledDays[j]){
                day = {"day": i, "color": "green"};
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
            weeks[weeks.length-1].push({"day": i ,"color": "grey"})
        }
    }

    return(
        weeks.map((week) =>{
            return(
                <tr>
                    {week.map((day) => {
                        return(
                            <td className='calendario_mini_day' style={{color: day.color}}> {day.day} </td>
                        )
                    })}
                </tr>
            )
        })
    )
}


/*
    El componente recibe 3 valores.
        -enabledDays: un json con el nombre del mes correspodiante al index como 
        llave, y una lista de los dias habiles.
            Ejemplo:
                {
                    "Abril": [1, 2, 3, 5, 20, 21, 30, 31]
                }

        -year: el año actual.
        -montIndex: El mes que se desea mostrar, por defecto es 0, y no puede 
        ser negativo.
        -minMonth: El primer mes que debe mostrar el minicalendario
        -maxMonth: El ultimo mes que debe mostrar el minicalendario

    Ejemplo:
        enabledDays={info} year="2022" monthIndex={3} minMonth={0} maxMonth={4}
    */
function CalendarioMini(/* {enabledDays, year, monthIndex, minMonth, maxMonth} */){

    const today = new Date()

    const navigate = useNavigate()

    useEffect(() => {
        // Si no se seleccionó una asesoría, se redirecciona al usuario al calendario
        if(!localStorage.asesoria_uf) {
            navigate('/calendario')
        }
    })
    
    const year = today.getFullYear() 
    const [month, setMonth] = useState(today.getMonth());

    const minMonth=0
    const maxMonth=4

    // const [enabledDays, setEnabledDays] = useState(requestDias(today.getMonth()))
    const [enabledDays, setEnabledDays] = useState({'Cargando': []})

    const [miniCalendario, setMiniCalendario] = useState(makeCalendarioMini(enabledDays, year, month));
    const [monthName, setMonthName] = useState(Object.keys(enabledDays));

    const requestDias = (mes) => {  
        const config = {
            method: 'get',
            url: `http://20.225.209.57:3094/asesoria/get_dias/?uf=${localStorage.asesoria_uf}&anio=${year}&mes=${mes}`,
            headers: { }
        }
        
        axios(config)
        .then(function (response) {
            console.log(response.data);
            setEnabledDays(response.data);
            setMonthName(Object.keys(response.data))
        })
        .catch(function (error) {
            alert("Error con API")
            console.log(error);
        });

        // try {
        //     const response = await axios(config)
        //     console.log(response.data);
        //     setEnabledDays(response.data);
        // } catch (error) {
        //     alert("Error con API")
        //     console.log(error);
        // }

    }

    

    const goLastMonth = () => {
        if(month > minMonth){
            setMonth(month - 1);
            let test = {"Marzo": [1,3,5,20,21,22,23]};
            setMiniCalendario(makeCalendarioMini(test, year, month -1));
            setMonthName(Object.keys(test));
        }
    };
    const goNextMonth = () => {
        if(month < maxMonth){
            setMonth(month + 1);
            //llamada al back para establecer nuevos enables days
            setMiniCalendario(makeCalendarioMini(enabledDays, year, month +1));
            setMonthName(Object.keys(enabledDays));
        }
    };

    return(
        <div className='calendario_mini_container'>
            <div className='calendario_mini_top'>
                <button type="button" className='buttonArrow' onClick={goLastMonth}><i className="arrow left"></i></button>
                <span>{monthName} - {new Date().getFullYear()}</span>
                <button type="button" className='buttonArrow' onClick={goNextMonth}><i className="arrow right"></i></button>
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

            <div>
                <button onClick={() => requestDias(4)}> request </button>
            </div>
        </div>
    )   
}
export default CalendarioMini
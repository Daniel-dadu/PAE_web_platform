import React , {useState} from 'react'
import "./CalendarioMini.css"

function CalendarioMini({calendar, year, monthIndex}){
    /*
    El componente recibe 3 valores.
        -calendar: un json con el nombre del mes correspodiante al index como 
        llave, y una lista de los dias habiles.
            Ejemplo:
                {
                    "Abril":
                            [
                                1,
                                2,
                                3,
                                5,
                                20,
                                21,
                                30,
                                31
                            ]
                }

        -year: el año actual.
        -montIndex: El mes que se desea mostrar, por defecto es 0, y no puede 
        ser negativo.

    Ejemplo:
        calendar={info} year="2022" monthIndex="0"
    */

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

    //Agrega lo primeros dias del proximo mes que estan presente en la ultima 
    //semana
    if(currentMontLastDay.getDay() < 6){
        for(let i = 1; i < 7 - currentMontLastDay.getDay(); i++){
            weeks[weeks.length-1].push({"day": i ,"color": "grey"})
        }
    }

    return(
        <div className='calendario_mini_container'>
            <div className='calendario_mini_top'>
                <button type="button" className='buttonArrow'><i className="arrow left"></i></button>
                <span>{Object.keys(calendar)} - {new Date().getFullYear()}</span>
                <button type="button" className='buttonArrow'><i className="arrow right"></i></button>
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
                    {weeks.map((week) =>{
                        return(
                            <tr>
                                {week.map((day) => {
                                    return(
                                        <td className='calendario_mini_day' style={{color: day.color}}> {day.day} </td>
                                    )
                                })}
                            </tr>
                        )
                    })}
                </tbody>
            </table>
        </div>
    )   
}
export default CalendarioMini
import React from 'react'
import "./CalendarioMini.css"

function CalendarioMini(props){
    /*
    El componente recibe 3 valores.
        -calendar: Es un json conformado por un array de meses (en donde el 
        primer mes es el mes actual), que a su vez estan conformados por 
        arrays de semanas, que a su vez estan conformadas por un array de dias.
        El mes incluye dias anteriores y posteriores con el fin de mostrarlos 
        visualmente.

            Ejemplo:
                {
                    "months" : [
                        {"Abril":
                            [
                                [
                                    {"27": null},
                                    ...
                                ],
                                ...
                            ]
                        },
                        ...
                    ]
                }

        -year: el año actual.
        -montIndex: El mes que se desea mostrar, por defecto es 0, y no puede 
        ser negativo.

    Ejemplo:
        calendar={info} year="2022" monthIndex="0"
    */

    return(
        <div className='calendario_mini_container'>
            <div className='calendario_mini_top'>
                <button type="button" className='buttonArrow'><i className="arrow left"></i></button>
                <span>{Object.keys(props.calendar.months[props.monthIndex])} - {props.year}</span>
                <button type="button" className='buttonArrow'><i className="arrow right"></i></button>
            </div>
            <table className='calendario_mini_month'>
                <tbody>
                    <tr>
                        <th className='calendario_mini_week_day'>Domingo</th>
                        <th className='calendario_mini_week_day'>Lunes</th>
                        <th className='calendario_mini_week_day'>Martes</th>
                        <th className='calendario_mini_week_day'>Mercoles</th>
                        <th className='calendario_mini_week_day'>Jueves</th>
                        <th className='calendario_mini_week_day'>Viernes</th>
                        <th className='calendario_mini_week_day'>Sabado</th>
                    </tr>
                    {Object.values(props.calendar.months[props.monthIndex]).map((weeks) => {
                        return (
                            weeks.map((week) => {
                                return (
                                    <tr>
                                    {week.map((day) => {
                                        return (
                                            <td className='calendario_mini_day' style={{color: Object.values(day).toString() === "true" ? "green" : Object.values(day).toString() === "false" ? "black" : "grey"}}><a href='.'>{Object.keys(day)}</a></td>
                                        )
                                    })}
                                    </tr>
                                )
                            })
                        )
                    })}
                </tbody>
            </table>
        </div>
    )   
}
export default CalendarioMini
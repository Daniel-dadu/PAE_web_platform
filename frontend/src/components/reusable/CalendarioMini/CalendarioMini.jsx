import React from 'react'
import "./CalendarioMini.css"

function CalendarioMini(props){
    {/*
    console.log(Object.keys(props.calendar.months[props.monthIndex]))
    console.log(Object.values(props.calendar.months[props.monthIndex]))
    {Object.values(props.calendar.months[props.monthIndex]).map((weeks) => {
        return (
            weeks.map((week) => {
                week.map((day) => {
                    console.log(Object.keys(day))
                })
            })
        )
    })};
    */}

    return(
        <div className='calendario_mini_container'>
            <div className='calendario_mini_top'>
                <button type="button"><i className="arrow left"></i></button>
                <span>{Object.keys(props.calendar.months[props.monthIndex])} - {props.year}</span>
                <button type="button"><i className="arrow right"></i></button>
            </div>
            <table className='calendario_mini_month'>
                <tbody>
                    <tr>
                        <th>Domingo</th>
                        <th>Lunes</th>
                        <th>Martes</th>
                        <th>Mercoles</th>
                        <th>Jueves</th>
                        <th>Viernes</th>
                        <th>Sabado</th>
                    </tr>
                    {Object.values(props.calendar.months[props.monthIndex]).map((weeks) => {
                        return (
                            weeks.map((week) => {
                                return (
                                    <tr>
                                    {week.map((day) => {
                                        return (
                                            <td style={{color: Object.values(day).toString() == "true" ? "green" : Object.values(day).toString() == "false" ? "black" : "grey"}}>{Object.keys(day)}</td>
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
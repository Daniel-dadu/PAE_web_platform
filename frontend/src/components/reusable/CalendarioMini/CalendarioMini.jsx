import React from 'react'
import "./CalendarioMini.css"

function CalendarioMini(props){
    /*
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
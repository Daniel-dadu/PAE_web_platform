/* eslint no-eval: 0 */

import React from 'react'
import '../../../index.css'
import './Calendario.css'
import { DiaCalendario } from '../../../routeIndex'
import dateFunctions from '../../../assets/reusableFunctions/dateFunctions.js'

const SIZES = [
    'normal',
    'grande',
    'reducido'
]

const Calendario = ({
    userTypeCalendario,
    diasCalendario,
    sizeCalendario,
    mes,
    anio
}) => {

    const CalendarioSize = SIZES.includes(sizeCalendario)
        ? sizeCalendario
        : SIZES[0];
    
    var firstDate = new Date(anio, dateFunctions.monthsEnNumero[mes], 1);
    var lastDate = new Date(anio, dateFunctions.monthsEnNumero[mes] + 1, 0);
    var calendarDates = [];

    for(let i = firstDate.getDate(); i <= lastDate.getDate(); i++){

        let currentDate = new Date(anio, dateFunctions.monthsEnNumero[mes], i);

        if(dateFunctions.getNameDay(currentDate.getDay()) != "Sabado" && dateFunctions.getNameDay(currentDate.getDay()) != "Domingo"){
            calendarDates[i] = dateFunctions.getNameDay(currentDate.getDay());
        }

    }

    firstDate = {
        numberDay: Object.keys(calendarDates)[0],
        indexDay: dateFunctions.getIndexDay[calendarDates[Object.keys(calendarDates)[0]]]
    };
    
    lastDate = {
        numberDay: Object.keys(calendarDates)[Object.keys(calendarDates).length - 1],
        indexDay: dateFunctions.getIndexDay[calendarDates[Object.keys(calendarDates)[Object.keys(calendarDates).length - 1]]]
    };
    
    // console.log(lastDate['numberDay']);
    // console.log(firstDate['indexDay']);
    
    // Object.keys(calendarDates).forEach(

    //     function eachKey(key){
    //         console.log('key: ' + key + ', value: ' + calendarDates[key]); // alerts value
    //     }

    // );

    return(

        <>
        <table
            className = {`calendario ${CalendarioSize}CalendarioSize`}
        >
            <tr>
                <th className = 'nombreDiaCalendario'> Lunes </th>
                <th className = 'nombreDiaCalendario'> Martes </th>
                <th className = 'nombreDiaCalendario'> Miércoles </th>
                <th className = 'nombreDiaCalendario'> Jueves </th>
                <th className = 'nombreDiaCalendario'> Viernes </th>
            </tr>

            <tr>
            {(
                Object.keys(calendarDates).slice(0, firstDate['indexDay']).map((dayNumber) => {

                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = '0'
                                    userType = {userTypeCalendario}
                                    numeroDia = 'X'
                                    size = {CalendarioSize}
                                >
                                </DiaCalendario>
                            </td>
                        </>
                    )
                })
            )}

            {(
                Object.keys(calendarDates).slice(0, 5 - firstDate['indexDay']).map((dayNumber) => {

                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? 1 : 0}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? eval(diasCalendario[dayNumber.toString()]['onClickDirectivo']) : {}}
                                    asesorias = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? diasCalendario[dayNumber.toString()] : {}}
                                    numeroDia = {dayNumber}
                                    size = {CalendarioSize}
                                >
                                </DiaCalendario>
                            </td>
                        </>
                    )
                })
            )}
            </tr>

            <tr>
            {(
                Object.keys(calendarDates).slice(5 - firstDate['indexDay'], 10 - firstDate['indexDay']).map((dayNumber) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? 1 : 0}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? eval(diasCalendario[dayNumber.toString()]['onClickDirectivo']) : {}}
                                    asesorias = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? diasCalendario[dayNumber.toString()] : {}}
                                    numeroDia = {dayNumber}
                                    size = {CalendarioSize}
                                >
                                </DiaCalendario>
                            </td>
                        </>
                    )
                })
            )}
            </tr>

            <tr>
            {(
                Object.keys(calendarDates).slice(10 - firstDate['indexDay'], 15 - firstDate['indexDay']).map((dayNumber) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? 1 : 0}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? eval(diasCalendario[dayNumber.toString()]['onClickDirectivo']) : {}}
                                    asesorias = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? diasCalendario[dayNumber.toString()] : {}}
                                    numeroDia = {dayNumber}
                                    size = {CalendarioSize}
                                >
                                </DiaCalendario>
                            </td>
                        </>
                    )
                })
            )}
            </tr>

            <tr>
            {(
                Object.keys(calendarDates).slice(15 - firstDate['indexDay'], 20 - firstDate['indexDay']).map((dayNumber) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? 1 : 0}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? eval(diasCalendario[dayNumber.toString()]['onClickDirectivo']) : {}}
                                    asesorias = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? diasCalendario[dayNumber.toString()] : {}}
                                    numeroDia = {dayNumber}
                                    size = {CalendarioSize}
                                >
                                </DiaCalendario>
                            </td>
                        </>
                    )
                })
            )}
            </tr>

            <tr>
            {(
                Object.keys(calendarDates).slice(20 - firstDate['indexDay'], 25 - firstDate['indexDay']).map((dayNumber) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? 1 : 0}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? eval(diasCalendario[dayNumber.toString()]['onClickDirectivo']) : {}}
                                    asesorias = {(diasCalendario.hasOwnProperty(dayNumber.toString())) ? diasCalendario[dayNumber.toString()] : {}}
                                    numeroDia = {dayNumber}
                                    size = {CalendarioSize}
                                >
                                </DiaCalendario>
                            </td>
                        </>
                    )
                })
            )}
            </tr>

        </table>
        </>

    );

};

export default Calendario
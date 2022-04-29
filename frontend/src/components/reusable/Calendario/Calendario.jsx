/* eslint no-eval: 0 */

import React from 'react'
import '../../../index.css'
import './Calendario.css'
import { DiaCalendario } from '../../../routeIndex'

const SIZES = [
    'normal',
    'grande',
    'reducido'
]

const Calendario = ({
    userTypeCalendario,
    diasCalendario,
    sizeCalendario
}) => {

    const CalendarioSize = SIZES.includes(sizeCalendario)
        ? sizeCalendario
        : SIZES[0];

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
                Object.keys(diasCalendario['diasCalendario']).slice(0, 5).map((index) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {diasCalendario['diasCalendario'][index]['isActive']}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {eval(diasCalendario['diasCalendario'][index]['onClickDirectivo'])}
                                    asesorias = {diasCalendario['diasCalendario'][index]}
                                    numeroDia = {diasCalendario['diasCalendario'][index]['numeroDia']}
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
                Object.keys(diasCalendario['diasCalendario']).slice(5, 10).map((index) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {diasCalendario['diasCalendario'][index]['isActive']}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {eval(diasCalendario['diasCalendario'][index]['onClickDirectivo'])}
                                    asesorias = {diasCalendario['diasCalendario'][index]}
                                    numeroDia = {diasCalendario['diasCalendario'][index]['numeroDia']}
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
                Object.keys(diasCalendario['diasCalendario']).slice(10, 15).map((index) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {diasCalendario['diasCalendario'][index]['isActive']}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {eval(diasCalendario['diasCalendario'][index]['onClickDirectivo'])}
                                    asesorias = {diasCalendario['diasCalendario'][index]}
                                    numeroDia = {diasCalendario['diasCalendario'][index]['numeroDia']}
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
                Object.keys(diasCalendario['diasCalendario']).slice(15).map((index) => {
                    return(
                        <>
                            <td className = 'bloqueCalendario'>
                                <DiaCalendario
                                    isActive = {diasCalendario['diasCalendario'][index]['isActive']}
                                    userType = {userTypeCalendario}
                                    onClickDirectivo = {eval(diasCalendario['diasCalendario'][index]['onClickDirectivo'])}
                                    asesorias = {diasCalendario['diasCalendario'][index]}
                                    numeroDia = {diasCalendario['diasCalendario'][index]['numeroDia']}
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
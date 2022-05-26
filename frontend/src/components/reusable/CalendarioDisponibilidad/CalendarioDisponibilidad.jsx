import React from 'react'
import '../../../index.css'
import './CalendarioDisponibilidad.css'

function selectHour(id){

    let hour = document.getElementById(id);

    if(window.getComputedStyle(hour).backgroundColor === 'rgb(196, 196, 196)'){
        hour.style.backgroundColor = '#B1FF96';
    }
    else{
        hour.style.backgroundColor = '#C4C4C4';
    }

}

const CalendarioDisponibilidad = () => {

    var diasCalendario = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes'];

    return(
        <>
        <table
            className = {`calendarioDisponibilidad`}
        >
            <tr>
                <th className = 'nombreDiaCalendarioDisponibilidad'> </th>
                <th className = 'nombreDiaCalendarioDisponibilidad'> Lunes </th>
                <th className = 'nombreDiaCalendarioDisponibilidad'> Martes </th>
                <th className = 'nombreDiaCalendarioDisponibilidad'> Miércoles </th>
                <th className = 'nombreDiaCalendarioDisponibilidad'> Jueves </th>
                <th className = 'nombreDiaCalendarioDisponibilidad'> Viernes </th>
            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 08:00 </p>
                    </div>
                </td>

                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}8`)} id = {`${index}8`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 09:00 </p>
                    </div>
                </td>

                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}9`)} id = {`${index}9`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 10:00 </p>
                    </div>
                </td>

                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}10`)} id = {`${index}10`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 11:00 </p>
                    </div>
                </td>
                
                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}11`)} id = {`${index}11`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 12:00 </p>
                    </div>
                </td>
                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}12`)} id = {`${index}12`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 13:00 </p>
                    </div>
                </td>
                
                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}13`)} id = {`${index}13`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 14:00 </p>
                    </div>
                </td>
                
                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}14`)} id = {`${index}14`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

            <td className = 'bloqueCalendarioDisponibilidad'>
                <div className = 'horaCalendarioDisponibilidad'>
                    <p className = 'txtHoraCalendarioDisponibilidad'> 15:00 </p>
                </div>
            </td>

            {(
                Object.keys(diasCalendario).slice(0, 5).map((index) => {
                    return(
                        <>
                            <td className = 'bloqueCalendarioDisponibilidad'>
                                <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}15`)} id = {`${index}15`}> </div>
                            </td>
                        </>
                    )
                })
            )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 16:00 </p>
                    </div>
                </td>

                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}16`)} id = {`${index}16`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 17:00 </p>
                    </div>
                </td>

                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}17`)} id = {`${index}17`}> </div>
                                </td>
                            </>
                        )
                    })
                )}

            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 18:00 </p>
                    </div>
                </td>

                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}18`)} id = {`${index}18`}> </div>
                                </td>
                            </>
                        )
                    })
                )}
                
            </tr>

            <tr>

                <td className = 'bloqueCalendarioDisponibilidad'>
                    <div className = 'horaCalendarioDisponibilidad'>
                        <p className = 'txtHoraCalendarioDisponibilidad'> 19:00 </p>
                    </div>
                </td>

                {(
                    Object.keys(diasCalendario).slice(0, 5).map((index) => {
                        return(
                            <>
                                <td className = 'bloqueCalendarioDisponibilidad'>
                                    <div className = 'seleccionCalendario' onClick = {() => selectHour(`${index}19`)} id = {`${index}19`}> </div>
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

export default CalendarioDisponibilidad
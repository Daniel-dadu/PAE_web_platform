/* eslint no-eval: 0 */

import React, { useEffect } from 'react'
import '../../../index.css'
import './DiaCalendario.css'
import { BotonSencillo } from '../../../routeIndex'

const SIZES = [
    'normal',
    'grande',
    'reducido'
]

const DiaCalendario = ({
    isActive,
        // 0 significa que no hay asesorías agendadas
        // 1 significa que hay asesorías agendadas
    userType, // Se usa si hay al menos una asesoría agendada
        // alumno
        // directivo
    onClickDirectivo, // Se usa solo si el tipo de usuario es un directivo
    asesorias, // Se usa solo si hay al menos una asesoría agendada y el tipo de usuario es 'alumno'
        // JSON con las asesorías del día
    numeroDia, // Número del día del componente
    size // Tamaño del componente
        // normal
        // grande
        // reducido
}) => {

    const ComponentSize = SIZES.includes(size)
        ? size
        : SIZES[0];

    useEffect(() => {
        isActiveOnAlumno()
    });

    return(
        <div
            className = {`dia ${ComponentSize}DiaSize ${(parseInt(isActive) ? 'active' : 'disable')}`}
        >
            <p className = 'numeroDia'> {numeroDia} </p>
            {(
                parseInt(isActive)
                    ? (userType === 'alumno')
                        ?
                            <div className = 'botonesAsesorias'>
                            {
                                Object.keys(asesorias['asesorias']).map((index) => {
                                    return(
                                        <>
                                        <div className = 'btnAsesoria'>
                                            <BotonSencillo
                                                onClick = {eval(asesorias['asesorias'][index]['openPanel'])} // Acción que ocurre al dar click en el botón
                                                backgroundColor = {(asesorias['asesorias'][index]['status'] === 'confirmada') ? 'azulCielo' : (asesorias['asesorias'][index]['status'] === 'finalizada') ? 'turquesa' : (asesorias['asesorias'][index]['status'] === 'reservada') ? 'amarillo' : 'rojo' }
                                                size = 'normal'
                                                    // normal
                                                    // largo
                                                    // reducido
                                                    // grande
                                            >
                                                {
                                                    (asesorias['asesorias'][index]['status'] === 'confirmada')
                                                        ? asesorias['asesorias'][index]['hora'] + ':00 hrs.'
                                                        : asesorias['asesorias'][index]['status']
                                                }
                                            </BotonSencillo>
                                        </div>
                                        </>
                                    )
                                })
                            }
                            </div>
                        :
                            <>
                            <div className = {`btnDirectivo ${ComponentSize}DiaSize`}>
                                <center>
                                    <BotonSencillo
                                        onClick = {onClickDirectivo} // Acción que ocurre al dar click en el botón
                                        backgroundColor = 'azulCielo'
                                        size = 'normal'
                                            // normal
                                            // largo
                                            // reducido
                                            // grande
                                    >
                                        Múltiples asesorías
                                    </BotonSencillo>
                                </center>
                            </div>
                            </>
                    : <p style={{ display: 'none' }}> No está activo </p>
            )}

        </div>
    );

};

const isActiveOnAlumno = () => {
    
    let dias = document.getElementsByClassName('dia');

    for(let i = 0; i < dias.length; i++){

        let asesoriasAlumno = dias[i].getElementsByClassName('btnAsesoria');

        if(asesoriasAlumno.length > 0){

            let numeroAsesorias = asesoriasAlumno.length;
            let sizeComponent = document.getElementsByClassName('dia')[0].clientHeight;
            
            let customPatron = (2 * (numeroAsesorias - 1));
            let transformPercent = (28 * numeroAsesorias - 1);
            let customHeight = sizeComponent / (numeroAsesorias + 3);
    
            for(let i = 0; i < asesoriasAlumno.length; i++){
                asesoriasAlumno[i].style.marginBottom = String(11 - customPatron) + 'px';
                asesoriasAlumno[i].style.transform = `translateY(${((180 - (15 * i)) - transformPercent) - (numeroAsesorias - 1)}%)`;
                asesoriasAlumno[i].style.msTransform = `translateY(${((180 - (15 * i)) - transformPercent) - (numeroAsesorias - 1)}%)`;
                asesoriasAlumno[i].firstChild.style.height = String(customHeight) + 'px';
                // asesoriasAlumno[i].firstChild.style.fontSize = String(20 - customPatron - (sizeComponent*.01)) + 'px';
            }
            
        }

    }

}

export default DiaCalendario
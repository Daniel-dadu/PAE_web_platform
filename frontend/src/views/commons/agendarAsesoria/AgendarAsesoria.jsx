import React from 'react'
import './AgendarAsesoria.css'

import { Template, BarraProgreso, TarjetaMaestraMini, BotonSencillo } from '../../../routeIndex'

let progressBar = {
    "currentStep": 1,
    "steps": [
        {
            "name" : "uno",
            "state": null,
            "next": "done"
        }, 
        {
            "name" : "dos",
            "state": null,
            "next": "enable"
        },
        {
            "name" : "tres",
            "state": null,
            "next": "enable"
        },
        {
            "name" : "cuatro",
            "state": null,
            "next": "enable"
        }
    ]
}

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

// Descripción de las propedades
/*
showAtrasBtn: se recibe un booleano que en caso de ser true, muestra el botón de atrás
showTarjetaMaestraMini: se recibe un booleano que en caso de ser true, muestra el contenido de children en la TarjetaMaestraMini
sizeTarjetaMaestraMini: tamaño de tarjeta maestra mini (normal o grande)
children: contenido que va dentro
*/

function AgendarAsesoria({showAtrasBtn, showTarjetaMaestraMini, sizeTarjetaMaestraMini, children}) {
  return (
    <Template user="asesorado" tema="claro" idioma="espanol" view="agendarAsesoria">
        <div className='container_titleProgress'>
            <h1 className='title_agendarAsesoria'>Agendar asesorías</h1>
            <BarraProgreso progress={progressBar}/>
        </div>

        <div className='container_tarjetaMaestraMini'>
            {showTarjetaMaestraMini ? (
            <TarjetaMaestraMini size={sizeTarjetaMaestraMini}>
                {children}
            </TarjetaMaestraMini>
            ) : children}
        </div>

        <div className='container_navButtons'>
            {showAtrasBtn ? (
            <div>
                <BotonSencillo onClick = {() => {alert('Me diste click :)')}} backgroundColor='turquesa' size='normal'>
                    Atras
                </BotonSencillo>
            </div> 
            ) : null}
            <div className="btn_right">
                <BotonSencillo onClick = {() => {alert('Me diste click :)')}} backgroundColor='gris' size='normal'>
                    Cancelar
                </BotonSencillo>
            </div>
            <div>
                <BotonSencillo onClick = {() => {alert('Me diste click :)')}} backgroundColor='verde' size='normal'>
                    Siguiente
                </BotonSencillo>
            </div>
        </div>

    </Template>
  )
}

export default AgendarAsesoria
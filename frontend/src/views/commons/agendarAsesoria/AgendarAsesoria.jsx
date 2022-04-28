import React from 'react'
import './AgendarAsesoria.css'

import { Template, BarraProgreso, TarjetaMaestraMini, BotonSencillo } from '../../../routeIndex'

let progressBar = {
    "currentStep": 0,
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

function AgendarAsesoria({children}) {
  return (
    <Template user="asesorado" tema="claro" idioma="espanol" view="agendarAsesoria">
        <h1>Agendar asesorías</h1>
        <BarraProgreso progress={progressBar}/>
        <div className='container_tarjetaMaestraMini'>
            <TarjetaMaestraMini size="normal">
                {children}
            </TarjetaMaestraMini>
        </div>

        <BotonSencillo onClick = {() => {alert('Me diste click :)')}} backgroundColor='gris' size='normal'>
            Cancelar
        </BotonSencillo>
        <BotonSencillo onClick = {() => {alert('Me diste click :)')}} backgroundColor='verde' size='normal'>
            Siguiente
        </BotonSencillo>

    </Template>
  )
}

export default AgendarAsesoria
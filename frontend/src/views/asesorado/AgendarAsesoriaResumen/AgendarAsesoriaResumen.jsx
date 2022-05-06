import React from 'react'
import './AgendarAsesoriaResumen.css'
import info from './info.json'
import { AgendarAsesoria, TarjetaInformacion } from '../../../routeIndex'

let progressBar = {
  "currentStep": 4,
  "steps": [
      {
          "name" : "Selección",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        }, 
        {
          "name" : "Información",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Fecha",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Hora",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
      }
  ]
}
function AgendarAsesoriaResumen() {

  return (
<AgendarAsesoria 
    showAtrasBtn={true} 
    btnAtrasRoute="./AgendarAsesoriaHora" 
    btnSiguienteRoute="./Calendario"
    showTarjetaMaestraMini={true} 
    sizeTarjetaMaestraMini="normal" 
    progressBarJSON={progressBar}>
        <div className='resumen_container'>
          <TarjetaInformacion info={info}/>
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaResumen
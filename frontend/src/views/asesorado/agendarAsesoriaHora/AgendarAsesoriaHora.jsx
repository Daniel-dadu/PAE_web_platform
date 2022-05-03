import React from 'react'
import './AgendarAsesoriaHora.css'
import info from './info.json'
import { AgendarAsesoria, SeleccionarHorarioAsesoria } from '../../../routeIndex'

let progressBar = {
  "currentStep": 3,
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
          "state": null,
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
function AgendarAsesoriaDuda() {

  return (
<AgendarAsesoria 
    showAtrasBtn={true} 
    btnAtrasRoute="./AgendarAsesoriaCalendario" 
    btnSiguienteRoute="./AgendarAsesoriaResumen"
    showTarjetaMaestraMini={true} 
    sizeTarjetaMaestraMini="normal" 
    progressBarJSON={progressBar}>
        <div className='horario_container'>
          <SeleccionarHorarioAsesoria date={info}/>
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaDuda
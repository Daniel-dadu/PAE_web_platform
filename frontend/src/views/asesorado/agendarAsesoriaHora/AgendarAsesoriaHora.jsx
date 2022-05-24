import React from 'react'
import './AgendarAsesoriaHora.css'
import { useParams } from "react-router-dom"

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
function AgendarAsesoriaHora() {

  const { anio, mes, dia } = useParams();


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
        <div>
          {anio} <br /> {mes} <br /> {dia}
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaHora
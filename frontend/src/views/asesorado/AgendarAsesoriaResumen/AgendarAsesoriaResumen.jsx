import React from 'react'
import { useParams } from "react-router-dom"
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

  // La propiedad de idAsesoria perimite conocer la asesoria que se está agendando en ese momento
  let { idAsesoria } = useParams();

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
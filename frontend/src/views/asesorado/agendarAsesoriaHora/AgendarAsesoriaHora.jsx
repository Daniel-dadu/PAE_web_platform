import React from 'react'
import './AgendarAsesoriaCalendario.css'
import info from './info.json'
import { AgendarAsesoria, CalendarioMini } from '../../../routeIndex'

let progressBar = {
  "currentStep": 2,
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
          "state": null,
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
    <AgendarAsesoria showAtrasBtn={true} showTarjetaMaestraMini={true} sizeTarjetaMaestraMini="normal" progressBarJSON={progressBar}>
        <div className='container-aad'>
          <CalendarioMini calendar={info} year="2022" monthIndex="0"/>
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaDuda
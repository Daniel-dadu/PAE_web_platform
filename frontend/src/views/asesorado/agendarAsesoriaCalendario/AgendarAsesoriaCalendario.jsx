import React from 'react'
import './AgendarAsesoriaCalendario.css'
import { AgendarAsesoria, CalendarioMini } from '../../../routeIndex'

let progressBar = {
  "currentStep": 2,
  "steps": [
      {
          "name" : "Selección",
          "state": true,
          "next": "enable",
          "path" : "/AgendarAsesoriaUF/ok"
        }, 
        {
          "name" : "Información",
          "state": true,
          "next": "enable",
          "path" : "/AgendarAsesoriaDuda"
        },
        {
          "name" : "Fecha",
          "state": null,
          "next": "enable",
          "path" : "/AgendarAsesoriaCalendario"
        },
        {
          "name" : "Hora",
          "state": null,
          "next": "enable",
          "path" : "/AgendarAsesoriaCalendario"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "/AgendarAsesoriaCalendario"
      }
  ]
}
function AgendarAsesoriaDuda() {

  return (
    <AgendarAsesoria 
    showAtrasBtn={true} 
    btnAtrasRoute="./AgendarAsesoriaDuda" 
    btnSiguienteProps={{view: 3, props: null}}
    showTarjetaMaestraMini={true} 
    sizeTarjetaMaestraMini="normal" 
    progressBarJSON={progressBar}>
        <div className='titles_calendarioMini_container'>
          <h2 className='title_instructions_agendarAsesoria'>Selecciona el día en el que quieres que se lleve a cabo tu asesoria</h2>
          <h4 className='subtitle_instructions_agendarAsesoria'>
            Solo los días en color <span style={{color: "#46CF16", fontWeight: '400'}}>verde</span> están disponibles
          </h4>
        </div>

        <div className='calendarioMini_container'>
          <CalendarioMini />
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaDuda
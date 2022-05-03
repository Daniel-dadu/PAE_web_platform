import React from 'react'
import './AgendarAsesoriaUF.css'

import info from './info.json'

import { AgendarAsesoria, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'

let progressBar = {
  "currentStep": 0,
  "steps": [
      {
          "name" : "Selección",
          "state": null,
          "next": "done",
          "path" : "./AgendarAsesoriaUF"
        }, 
        {
          "name" : "Información",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        },
        {
          "name" : "Fecha",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        },
        {
          "name" : "Hora",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
      }
  ]
}

function AgendarAsesoriaUF() {

  return (
    <AgendarAsesoria 
      showAtrasBtn={false} 
      btnAtrasRoute="" 
      btnSiguienteRoute="./AgendarAsesoriaDuda" 
      showTarjetaMaestraMini={true} 
      sizeTarjetaMaestraMini="normal" 
      progressBarJSON={progressBar}
    >
      <div className='container_out_aauf'>
        <div className='container_in_aauf'>
          <h3>Carrera</h3>
          <CampoSeleccionarEnListaDesplegable size="medium" options={info.carrera} idList="semestre"/>
          <h3>Semestre</h3>
          <CampoSeleccionarEnListaDesplegable size="small" options={info.semestre} idList="carrera"/>
          <h3>Unidad de formación</h3>
          <CampoSeleccionarEnListaDesplegable size="medium" options={info.unidadFormacion} idList="unidadFormacion"/>
        </div>
      </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaUF
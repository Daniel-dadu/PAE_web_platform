import React from 'react'
import './AgendarAsesoriaUF.css'

import info from './info.json'

import { AgendarAsesoria, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'

function AgendarAsesoriaUF() {

  return (
    <AgendarAsesoria showAtrasBtn={false} showTarjetaMaestraMini={true} sizeTarjetaMaestraMini="normal">
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
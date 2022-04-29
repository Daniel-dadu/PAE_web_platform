import React from 'react'
import './AgendarAsesoriaUF.css'

import info from './info.json'

import { AgendarAsesoria, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'

function AgendarAsesoriaUF() {

  return (
    <AgendarAsesoria showAtrasBtn={false} showTarjetaMaestraMini={true} sizeTarjetaMaestraMini="normal">
        <h3>Carrera</h3>
        <CampoSeleccionarEnListaDesplegable size="medium" options={info.semestre}/>
        <h3>Semestre</h3>
        <CampoSeleccionarEnListaDesplegable size="small" options={info.carrera}/>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaUF
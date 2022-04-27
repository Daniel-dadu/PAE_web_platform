import React from 'react'
import { BarraProgreso } from '../../../routeIndex'
import info from  './progreso.json'

function Fernando() {
  return (
    <div>
      <BarraProgreso progress={info.uno}/>
      <BarraProgreso progress={info.dos}/>
      <BarraProgreso progress={info.tres}/>
      <BarraProgreso progress={info.cuatro}/>
    </div>
  )
}

export default Fernando
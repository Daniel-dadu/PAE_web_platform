import React from 'react'
import { BarraProgreso } from '../../../routeIndex'
import info from  './progreso.json'
import './Fernando.css'

function Fernando() {
  return (
    <div className='divWN'>
      <BarraProgreso progress={info.uno}/>
      <BarraProgreso progress={info.dos}/>
      <BarraProgreso progress={info.tres}/>
      <BarraProgreso progress={info.cuatro}/>
    </div>
  )
}

export default Fernando
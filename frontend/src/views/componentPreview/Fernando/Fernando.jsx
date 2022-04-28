import React from 'react'
import { SeleccionarHorarioAsesoria } from '../../../routeIndex'
import info from  './horario.json'
import './Fernando.css'

function Fernando() {
  return (
    <div className='divW500'>
      <SeleccionarHorarioAsesoria date={info}/>
    </div>
  )
}

export default Fernando
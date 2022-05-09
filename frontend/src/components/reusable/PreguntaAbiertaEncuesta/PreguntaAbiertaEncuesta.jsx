import React from 'react'

import './PreguntaAbiertaEncuesta.css'
import {  CampoTextoGrande } from '../../../routeIndex'

function PreguntaAbiertaEncuesta({preguntaAbierta}) {
  return (
    <div className='contenedorPreguntaAbiertaEncuesta'>
        <div className='textoPreguntaAbiertaEncuesta'> {preguntaAbierta} </div>

        <div> <CampoTextoGrande></CampoTextoGrande></div>

    </div>
  )
}

export default PreguntaAbiertaEncuesta
import React from 'react'

import './PreguntaAbiertaEncuesta.css'
import {  CampoTextoGrande } from '../../../routeIndex'



// eslint-disable-next-line no-lone-blocks
{/* <PreguntaAbiertaEncuesta 

preguntaAbierta={'Aqui pon la pregunta que quieras'}>

</PreguntaAbiertaEncuesta> */}

function PreguntaAbiertaEncuesta({preguntaAbierta}) {
  return (
    <div className='contenedorPreguntaAbiertaEncuesta'>
        <div className='textoPreguntaAbiertaEncuesta'> {preguntaAbierta} </div>

        <div> <CampoTextoGrande></CampoTextoGrande></div>

    </div>
  )
}

export default PreguntaAbiertaEncuesta
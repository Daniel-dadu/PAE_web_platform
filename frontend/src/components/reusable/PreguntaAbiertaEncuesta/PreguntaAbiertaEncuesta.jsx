import React from 'react'

import './PreguntaAbiertaEncuesta.css'
import {  CampoTextoGrande } from '../../../routeIndex'



// eslint-disable-next-line no-lone-blocks
{/* <PreguntaAbiertaEncuesta 

preguntaAbierta={'Aqui pon la pregunta que quieras'}>

</PreguntaAbiertaEncuesta> */}

function PreguntaAbiertaEncuesta({preguntaAbierta, indexPregunta=1, respuesta=''}) {
  return (
    <div className='contenedorPreguntaAbiertaEncuesta'>
        <div className='textoPreguntaAbiertaEncuesta'> {preguntaAbierta} </div>

        <div> <CampoTextoGrande defaultText={ respuesta} >  </CampoTextoGrande></div>

    </div>
  )
}

export default PreguntaAbiertaEncuesta
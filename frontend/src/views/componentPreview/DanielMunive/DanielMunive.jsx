import React from 'react'
import { PreguntaAbiertaEncuesta }  from '../../../routeIndex'

import Logo from "./imgPrueba/RespuestasEncuestas.png";

import './Munive.css'
function DanielMunive() {


  return (
    <>
    <div // Div de prueba 
      className = 'containerImg'
      style = {{
        width: '100%',
        height: '150px',
        marginLeft: 'auto',
        marginRight: 'auto'
      }}
    >


      <PreguntaAbiertaEncuesta 

      preguntaAbierta={'Deja tu comentario aqui'}>

      </PreguntaAbiertaEncuesta>

    </div>
  </>


  )
}

export default DanielMunive
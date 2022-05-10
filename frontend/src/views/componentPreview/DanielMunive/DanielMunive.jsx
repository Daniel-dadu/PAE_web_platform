import React from 'react'
import { PreguntaCerradaEncuesta }  from '../../../routeIndex'

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


      <PreguntaCerradaEncuesta

        preguntaCerrada={'Deja tu calificacion aqui'}>

      </PreguntaCerradaEncuesta>

    </div>
  </>


  )
}

export default DanielMunive
<<<<<<< HEAD
import React, { useState } from 'react'
import { PreguntaAbiertaEncuesta }  from '../../../routeIndex'




=======
import React from 'react'
import { BotonAdministrarInformacion }  from '../../../routeIndex'

import Logo from "./imgPrueba/RespuestasEncuestas.png";
>>>>>>> develop

import './Munive.css'
function DanielMunive() {

<<<<<<< HEAD


  return (
    <div // Div de prueba para la imagen
         class = 'containerImg'
         style = {{
           width: '100%',
           height: '150px',
           marginLeft: 'auto',
           marginRight: 'auto'
         }}
       >

         <PreguntaAbiertaEncuesta preguntaAbierta='Deja tu Comentario :D'></PreguntaAbiertaEncuesta>
         
       </div>
=======

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


      <BotonAdministrarInformacion 
      onClick={() => {alert('Me diste click :)')}} 
      Imagen={Logo}
      children='Respuestas de encuestas a asesorados'>

      </BotonAdministrarInformacion>

    </div>
  </>

>>>>>>> develop

  )
}

export default DanielMunive
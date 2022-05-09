import React, { useState } from 'react'
import { PreguntaAbiertaEncuesta }  from '../../../routeIndex'





import './Munive.css'
function DanielMunive() {



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

  )
}

export default DanielMunive
import React from 'react'
import { BotonAdministrarInformacion }  from '../../../routeIndex'

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


      <BotonAdministrarInformacion 
      onClick={() => {alert('Me diste click :)')}} 
      Imagen={Logo}
      children='Respuestas de encuestas a asesorados'>

      </BotonAdministrarInformacion>

    </div>
  </>


  )
}

export default DanielMunive
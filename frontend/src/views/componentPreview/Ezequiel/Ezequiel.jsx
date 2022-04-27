import React from 'react'
import { BotonSencillo } from '../../../routeIndex'

function Ezequiel() {
  return (
    <BotonSencillo
      onClick = {() => {alert('Me diste click :)')}}
      type = 'button'
      buttonStyle = 'gris'
      buttonSize = 'normal'
    >
      Botón de prueba
    </BotonSencillo>
  )
}

export default Ezequiel
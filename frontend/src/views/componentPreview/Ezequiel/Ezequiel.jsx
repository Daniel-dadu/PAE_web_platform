import React from 'react'
import { BotonSencillo } from '../../../routeIndex'

function Ezequiel() {
  return (
    <BotonSencillo
      onClick = {() => {alert('Me diste click :)')}}
      type = 'button'
      buttonStyle = 'btn--style--normal'
      buttonSize = 'btn--size--large'
    >
      Botón de prueba
    </BotonSencillo>
  )
}

export default Ezequiel
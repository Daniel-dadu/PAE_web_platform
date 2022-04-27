import React from 'react'
import { BotonSencillo } from '../../../routeIndex'

function Ezequiel() {
  return (
    <BotonSencillo
      onClick = {() => {alert('Me diste click :)')}}
      backgroundColor = 'verde'
      size = 'normal'
    >
      Aceptar
    </BotonSencillo>
  )
}

export default Ezequiel
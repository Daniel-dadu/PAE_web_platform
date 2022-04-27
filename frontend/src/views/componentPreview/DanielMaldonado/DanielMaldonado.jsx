import React from 'react'
import { BarraLateral, TarjetaMaestra } from '../../../routeIndex'
import './DanielMaldonado.css'

function DanielMaldonado() {
  return (
    <div className="container">
      <BarraLateral userProp="asesor" temaProp="claro" idiomaProp="espanol" viewProp="calendario"/>
      <TarjetaMaestra />
    </div>
  )
}

export default DanielMaldonado
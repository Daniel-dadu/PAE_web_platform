import React from 'react'
import { BarraLateral, TarjetaMaestra, BotonConImagen } from '../../../routeIndex'
import './DanielMaldonado.css'

function DanielMaldonado() {
  return (
    <div className="container">
      <BarraLateral userProp="asesor" temaProp="claro" idiomaProp="espanol" viewProp="calendario"/>
      <TarjetaMaestra>
        <BotonConImagen onClick = {() => {alert('Me diste click :)')}} backgroundColor = 'verde' size = 'reducido'>
          Cerrar Sesión
        </BotonConImagen>
      </TarjetaMaestra>
    </div>
  )
}

export default DanielMaldonado
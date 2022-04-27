import React from 'react'
import { BarraLateral, TarjetaMaestra, BotonConImagen } from '../../../routeIndex'
import './DanielMaldonado.css'
import { IoMdCopy } from 'react-icons/io'

function DanielMaldonado() {
  return (
    <div className="container">
      <BarraLateral userProp="asesor" temaProp="claro" idiomaProp="espanol" viewProp="calendario"/>
      <TarjetaMaestra>
        <BotonConImagen onClick = {() => {alert('Me diste click :)')}} backgroundColor = 'verde' size = 'reducido' Image={IoMdCopy}>
          Cerrar sesion
        </BotonConImagen>
      </TarjetaMaestra>
    </div>
  )
}

export default DanielMaldonado
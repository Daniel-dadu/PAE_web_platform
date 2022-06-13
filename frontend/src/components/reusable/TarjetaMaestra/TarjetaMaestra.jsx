import React from 'react'
import './TarjetaMaestra.css'

function TarjetaMaestra({ viewRegistro, children }) {
  return (
    <div className={ viewRegistro ? 'tarjeta_maestra' : 'tarjeta_maestra_noRegistro' }>
      {children}
    </div>
  )
}

export default TarjetaMaestra

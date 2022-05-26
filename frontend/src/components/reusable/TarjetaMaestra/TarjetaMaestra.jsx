import React from 'react'
import './TarjetaMaestra.css'

function TarjetaMaestra({ viewRegistro, children }) {
  return (
    <div className='tarjeta_maestra' style={{height: viewRegistro ? '100%' : '90vh'}}>
      {children}
    </div>
  )
}

export default TarjetaMaestra

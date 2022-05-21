import React from 'react'
import './TarjetaMaestra.css'

function TarjetaMaestra(props) {
  return (
    <div className='tarjeta_maestra' style={{height: props.viewRegistro ? '100%' : '90vh'}}>
      {props.children}
    </div>
  )
}

export default TarjetaMaestra

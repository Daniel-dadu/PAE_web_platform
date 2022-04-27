import React from 'react'
import './TarjetaMaestra.css'

function TarjetaMaestra(props) {
  return (
    <div className='tarjeta_maestra'>
      {props.children}
    </div>
  )
}

export default TarjetaMaestra
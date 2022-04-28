import React from 'react'
import './TarjetaMaestraMini.css'

// Descripción de las propedades
/*
size: se recibe un string que puede ser "normal" o "big"
children: contenido que va dentro
*/

function TarjetaMaestraMini({ size, children }) {
  return (
    <div className='tarjeta_maestra_mini' style={{width: size === "normal" ? "60%" : "90%"}}>
        {children}
    </div>
  )
}

export default TarjetaMaestraMini
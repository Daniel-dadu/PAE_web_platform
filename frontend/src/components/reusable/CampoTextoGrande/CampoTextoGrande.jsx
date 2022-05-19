import React from 'react'
import './CampoTextoGrande.css'

// Descripción de las propedades
/*
size: se recibe un string que puede ser "small", "medium" o "big"
*/

function CampoTextoGrande({ size, parentCallback }) {

  const onTrigger = (texto) => parentCallback(texto)

  return (
    <div className="container_ctg">
        <textarea 
          type="text" 
          rows="6" 
          style={{width: size === "small" ? "150px" : size === "medium" ? "350px" : "100%"}} 
          onChange={(input) => onTrigger(input.target.value)}
        />
    </div>
  )
}

export default CampoTextoGrande
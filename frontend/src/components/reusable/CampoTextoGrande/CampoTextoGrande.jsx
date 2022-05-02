import React from 'react'
import './CampoTextoGrande.css'

// Descripción de las propedades
/*
size: se recibe un string que puede ser "small", "medium" o "big"
*/

function CampoTextoGrande({ size }) {
  return (
    <div className="container_ctg">
        <textarea type="text" rows="6" style={{width: size === "small" ? "150px" : size === "medium" ? "350px" : "100%"}}/>
    </div>
  )
}

export default CampoTextoGrande
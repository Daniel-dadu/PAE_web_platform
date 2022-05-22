import React from 'react'
import './CampoTextoPequeno.css'

// Descripción de las propedades
/*
size: se recibe un string que puede ser "small", "medium" o "big"
*/


function CampoTextoPequeno({ size, onInsertText }) {

  return (
    <div className="container_ctp">
        <input 
          type="text" 
          style={{width: size === "small" ? "150px" : size === "medium" ? "350px" :  size === "big" ? "600px" : "80%" }} 
          onChange={(input) => onInsertText(input.target.value)} />
    </div>
  )
}

export default CampoTextoPequeno
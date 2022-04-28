import React from 'react'
import './CampoSeleccionarEnListaDesplegable.css'

import { FiChevronDown } from 'react-icons/fi';

// Descripción de las propedades
/*
size: se recibe un string que puede ser "small", "medium" o "big"
options: se recibe un array de strings con las opciones que se deben mostrar
*/

function CampoSeleccionarEnListaDesplegable({ size, options }) {
  return (
    <div className="container_cseld">
      <input list="browsers" name="browser" id="browser" style={{width: size === "small" ? "100px" : size === "medium" ? "250px" : "350px"}}/>
      <FiChevronDown className="arrow_down" size={30} />
      <datalist id="browsers">
        {options.map((opcion) => (
          <option value={opcion} />
        ))}
      </datalist>
    </div>
  )
}

export default CampoSeleccionarEnListaDesplegable
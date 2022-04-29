import React from 'react'
import './CampoSeleccionarEnListaDesplegable.css'

import { FiChevronDown } from 'react-icons/fi';

// Descripción de las propedades
/*
size: se recibe un string que puede ser "small", "medium" o "big"
idList: se recibe un string que relaciona el input con la lista. Puede ser cualquier conjunto de caracteres como "miLista"
options: se recibe un array de strings con las opciones que se deben mostrar

EJEMPLO:
<CampoSeleccionarEnListaDesplegable size="small" options={info.semestre} idList="carrera"/>
*/

function CampoSeleccionarEnListaDesplegable({ size, idList, options }) {
  return (
    <div className="container_cseld">
      <input list={idList} style={{width: size === "small" ? "100px" : size === "medium" ? "250px" : "350px"}}/>
      <FiChevronDown className="arrow_down" size={30} />
      <datalist id={idList}>
        {options.map((opcion) => (
          <option value={opcion} />
        ))}
      </datalist>
    </div>
  )
}

export default CampoSeleccionarEnListaDesplegable
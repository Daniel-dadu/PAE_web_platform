import React from 'react'
import DatalistInput from 'react-datalist-input';
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

function CampoSeleccionarEnListaDesplegable({ size, parentCallback, options }) {

  // Función que envía al componente padre el valor del elemento seleccionado
  const onTrigger = (selectedItem) => parentCallback(selectedItem)

  return (
    <div className="container_cseld">
      <DatalistInput
        style={{width: size === "small" ? "100px" : size === "medium" ? "250px" : "350px"}}
        onSelect={(item) => onTrigger(item)}
        items={options.map((option) => { return {id: option, value: option}})}
      />
      <FiChevronDown className="arrow_down" size={30} />
    </div>
  )
}

export default CampoSeleccionarEnListaDesplegable
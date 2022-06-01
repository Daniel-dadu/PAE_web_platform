import React, { useEffect } from 'react'
import { DatalistInput, useComboboxControls } from 'react-datalist-input';
import './CampoSeleccionarEnListaDesplegable.css'

import { FiChevronDown } from 'react-icons/fi';
import { ImCross } from 'react-icons/im';

// Descripción de las propedades
/*
size: se recibe un string que puede ser "small", "medium" o "big"
idList: se recibe un string que relaciona el input con la lista. Puede ser cualquier conjunto de caracteres como "miLista"
options: se recibe un array de strings con las opciones que se deben mostrar

EJEMPLO:
<CampoSeleccionarEnListaDesplegable size="small" options={info.semestre} idList="carrera"/>
*/

function CampoSeleccionarEnListaDesplegable({ size, parentCallback, options, defaultValue='', placeholder='' }) {

  const { value, setValue } = useComboboxControls()

  useEffect(() => {
    if(defaultValue !== '') {
      setValue(defaultValue)
    }
  }, [setValue, defaultValue])

  // Función que envía al componente padre el valor del elemento seleccionado
  const onTrigger = selectedItem => parentCallback(selectedItem)

  const clearInput = () => {
    setValue('')
    onTrigger('')
  }
  

  return (
    <div className="container_cseld">
      <DatalistInput
        placeholder={placeholder}
        value={value}
        setValue={setValue}
        style={{width: size === "small" ? "100px" : size === "medium" ? "250px" : "350px"}}
        onSelect={item => onTrigger(item)}
        items={options.map((option) => { return {id: option, value: option}})}
        isExpandedStyle={{overflow: 'auto', height: options.length > 4 ? '10rem' : 'auto'}}
      />
      {
        value ? 
        <ImCross className="cross_clear" size={22} onClick={() => clearInput()} style={{right: size === "small" ? '7%' : '3.5%'}} />
        :
        <FiChevronDown className="arrow_down" size={30} />
      }
    </div>
  )
}

export default CampoSeleccionarEnListaDesplegable
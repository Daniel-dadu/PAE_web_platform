import React from 'react'
import './CambioMesPeriodo.css';
import { MdArrowBackIos } from 'react-icons/md';
import { MdArrowForwardIos } from 'react-icons/md';

/*
Para usar este componente, es necesario pasarle como parámetro lo siguiente:
- dataSupInf: se recibe un objecto de JS que cuente con los atributos de textoSuperior y textoInferior
  - ejemplo: { textoSuperior: 'Mayo', textoInferior: 2022 }
  - Nota IMPORTANTE: dicho objeto debe manejarse como una variable useState para que cuando se le de click a las flechas, cambie su contenido
- onClickArrow: se recibe una función que se ejecuta al darle click a alguna de las flechas
  - cada flecha manda un parámetro diferente a la función para indicar qué flecha fue la que se presionó

EJEMPLO:
<CambioMesPeriodo dataSupInf={{textoSuperior: 'Mayo', textoInferior: 2022}} onClickArrow={handleArrowClick} />

// Revisar código de /views/commons/calendario/Calendario.jsx para ver un ejemplo del uso del componente
*/
export default function CambioMesPeriodo({dataSupInf, onClickArrow}) {

  return (
    <div className="slideshow-container">
      <div> 
        <button className='back' onClick={() => onClickArrow('back')} >
          <MdArrowBackIos size={35} /> 
        </button>
      </div>

      <div className='bloqueTexto'>
        <div className='textSup'> { dataSupInf.textoSuperior } </div>
        <div className='textInf'> { dataSupInf.textoInferior } </div>
      </div>
      
      <div>
        <button className='next' onClick={() => onClickArrow('next')} > 
          <MdArrowForwardIos size={35} /> 
        </button>
      </div>
    </div>

  )


}

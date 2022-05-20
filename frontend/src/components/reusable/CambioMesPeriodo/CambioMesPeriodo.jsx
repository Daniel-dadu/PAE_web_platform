import React from 'react'
import './CambioMesPeriodo.css';
import { MdArrowBackIos } from 'react-icons/md';
import { MdArrowForwardIos } from 'react-icons/md';

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

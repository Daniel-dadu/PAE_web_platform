import React, { useState } from 'react'
import { ReactDOM } from 'react';
import './CambioMesPeriodo.css';
import './Slides.js'


export default function CambioMesPeriodo() {
  return (

    <div className='slideshow-container'> 
    
    <div className='mySlides'>
      <p className='.textSup'>TextoSuperior 1</p>
      <p className='textInf'>TextoInferior 1</p>
    </div>
    
    <div className='mySlides'>
      <p className='.textSup'>TextoSuperior 2</p>
      <p className='textInf'>TextoInferior 2</p>
    </div>

    <div className='mySlides'>
      <p className='.textSup'>TextoSuperior 3</p>
      <p className='textInf'>TextoInferior 3</p>
    </div>

    <a class="prev" onclick="plusSlides(-1)">❮</a>
    <a class="next" onclick="plusSlides(1)">❯</a>
    
    </div>
    

  )


}

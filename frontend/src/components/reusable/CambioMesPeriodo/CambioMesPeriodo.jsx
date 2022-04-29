import React from 'react'
import './CambioMesPeriodo.css';
import { useState } from "react";
import { MdArrowBackIos } from 'react-icons/md';
import { MdArrowForwardIos } from 'react-icons/md';

/* This is how you call de component

    <CambioMesPeriodo dataSupInf={  [ 
  {id: 1,
  Sup: 'Texto Superior 1',
  Inf: 'Texto Inferior 1'},

  {id: 2,
  Sup: 'Texto Superior 2',
  Inf: 'Texto Inferior 2'},

  {id: 3,
  Sup: 'Texto Superior 3',
  Inf: 'Texto Inferior 3'}   ]  } > </CambioMesPeriodo>

*/

export default function CambioMesPeriodo({dataSupInf}) {

const slidesArray =  dataSupInf 

  const [id, setId] = useState(1);

  const values = slidesArray.length;

  let validSlide = slidesArray.filter(slides => slides.id === (id))


  return (

   
    
    <div className="slideshow-container">  



        <div> 
        <button className='back' onClick={() => setId(id !== 1 ? id-1 : id) } > <MdArrowBackIos size={35} > </MdArrowBackIos> </button>
        </div>

        

        <div className='Bloque de Texto'>
        <div className='textSup'> {validSlide[0].Sup} </div>
        <div className='textInf'> {validSlide[0].Inf} </div>
        </div>
        
        <div>
        <button className='next' onClick={() => setId(id < values ? id+1 : id)} > <MdArrowForwardIos size={35} > </MdArrowForwardIos> </button>
        </div>
        

        

   </div>


  )


}

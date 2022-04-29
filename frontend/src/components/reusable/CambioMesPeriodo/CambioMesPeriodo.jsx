import React from 'react'
import './CambioMesPeriodo.css';
import { useState } from "react";
import { MdArrowBackIos } from 'react-icons/md';
import { MdArrowForwardIos } from 'react-icons/md';

export default function CambioMesPeriodo(Array) {
 const slidesArray = Array /* [
  {id: 1,
  Sup: 'Texto Superior 1',
  Inf: 'Texto Inferior 1'},

  {id: 2,
  Sup: 'Texto Superior 2',
  Inf: 'Texto Inferior 2'},

  {id: 3,
  Sup: 'Texto Superior 3',
  Inf: 'Texto Inferior 3'} ] */

  const [id, setId] = useState(1);

  const values = slidesArray.length;

  let validSlide = slidesArray.filter(slides => slides.id === (id))


  return (
    
    <div className="slideshow-container">  
        <div>
        <p> {validSlide[0].Sup} </p>
        <p> {validSlide[0].Inf} </p>
        </div>
        
        
        <button onClick={() => setId(id !== 1 ? id-1 : id)} > <MdArrowBackIos> </MdArrowBackIos> </button>

        <button onClick={() => setId(id < values ? id+1 : id)} > <MdArrowForwardIos> </MdArrowForwardIos> </button>

   </div>


  )


}

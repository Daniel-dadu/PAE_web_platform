import React, { useState } from 'react'
import { ReactDOM } from 'react';
import './CambioMesPeriodo.css';
import { MdArrowBackIos } from 'react-icons/md'
import { MdOutlineArrowForwardIos } from 'react-icons/md'


export default function CambioMesPeriodo() {
  const mesesAnos = [
    {mes: "Enero", ano: 2022},
    {mes: "Febrero", ano: 2022},
    {mes: "Marzo", ano: 2022},
    {mes: "Abril", ano: 2022},
    {mes: "Mayo", ano: 2022},
    {mes: "Junio", ano: 2022},
    {mes: "Julio", ano: 2022},
    {mes: "Agosto", ano: 2022},
    {mes: "Septiembre", ano: 2022},
    {mes: "Octubre", ano: 2022},
    {mes: "Noviembre", ano: 2022},
    {mes: "Diciembre", ano: 2022}]
  return (
    <div className='containerCambioMP'> 

    <div className='arrowBackMP'>
      <button onClick={ <p>HOLA</p>}> <MdArrowBackIos /> </button>

    </div>

    <div className='textMP'>
      <div className='textSup'> {mesesAnos.map(mes => <p>{mesesAnos}</p>)} </div>
      <div className='textInf'> Texto Inf</div>
    </div>
      
    <div className='arrowForwardMP'>
      <button>  <MdOutlineArrowForwardIos/> </button>
    </div>


    </div>
    

  )


}

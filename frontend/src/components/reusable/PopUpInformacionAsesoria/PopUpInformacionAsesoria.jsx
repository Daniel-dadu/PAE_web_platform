import React, { Component } from 'react'
import './infoAsesorias.css';
import { ImCross } from 'react-icons/im';
import asesoriaEjemplo from "./asesoriaEjemplo.json"

export default function PopUpInformacionAsesoria() {
    return (
      <div>
        <div class= "container">
          
          <div className='one'>
            <a href="#"><ImCross className='close'> </ImCross></a>      
            <p className= "titulo">Asesoria del {asesoriaEjemplo.Asesoria.numeroDia} de  {asesoriaEjemplo.Asesoria.mes} </p> 
          </div>
  
          <div className='two'>
  
                <div className='subtitulo'>Hora: <p className='informacion'>{asesoriaEjemplo.Asesoria.hora}</p> </div>
              <div className='subtitulo'>Asesor: <p className='informacion'>{asesoriaEjemplo.Asesoria.asesor}</p> </div> 
              <div className='subtitulo'>Asesorado: <p className='informacion'>{asesoriaEjemplo.Asesoria.asesorado}</p> </div> 
              <div className='subtitulo'>Lugar: <p className='informacion'>{asesoriaEjemplo.Asesoria.lugar}</p> </div>           
              <div className='subtitulo'>Unidad de formacion: <p className='informacion'>{asesoriaEjemplo.Asesoria.uF}</p> </div>
              <div className='subtitulo'>Duda: <p className='informacion'>{asesoriaEjemplo.Asesoria.duda}</p> </div>
            
                 
          </div>
  
          <div className='three'>
            <p className='subtitulo'>Imagenes adjutas de Lozanosoft</p>
          </div>
  
          <div className='four'>
            <p className='subtitulo'>Botones de Lozanosoft</p>
          </div>
          
        </div>
      </div>
    )
  }
  

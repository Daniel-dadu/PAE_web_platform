import React, { Component } from 'react'
import './infoAsesorias.css';
import { ImCross } from 'react-icons/im';
import asesoriaEjemplo from "./asesoriaEjemplo.json"
import { BotonSencillo }  from '../../../routeIndex'
import {ImagenAsesoria} from '../../../routeIndex'

export default function PopUpInformacionAsesoria({images, userTypePopUpAsesoria}) {
    return (
      <div>
        <div class= "container">
          
          <div className='one'>
            <a href=""><ImCross className='close'> </ImCross></a>      
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

          <div>
            <p className='subtitulo'>Imágenes adjuntadas:</p>
          </div>
  
          <div className='three'>

            {images.map((image) => {
              return <div><ImagenAsesoria
              allowClosed = '0'
              size = 'reducida'
              source = {image}
              alt = 'Debian'
              nameDownloadImage = 'La imagen de Debian'
              > </ImagenAsesoria> </div>
            })}   
          

          </div>

          {(userTypePopUpAsesoria === 'alumno') ?

          <div className='four'>

           <div className='fourBox'> <BotonSencillo backgroundColor="rojo" size='reducido' children="No llegó el asesor"></BotonSencillo> </div>  
           
           <div className='fourBox'> <BotonSencillo  backgroundColor="gris" size='reducido' children="Cancelar asesoría"></BotonSencillo> </div>

          </div>

          : <div className='four'> 

            <div className='fourBox'> <BotonSencillo  backgroundColor="gris" size='reducido' children="Cancelar asesoría"></BotonSencillo> </div>

            </div> }



          <div>
          </div>
          
        </div>
      </div>
    )
  }
  

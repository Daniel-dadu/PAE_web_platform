import React from 'react'
import './infoAsesorias.css';
import { ImCross } from 'react-icons/im';

import { BotonSencillo }  from '../../../routeIndex'
import { ImagenAsesoria } from '../../../routeIndex'

import  Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal';

export default function PopUpInformacionAsesoria({userTypePopUpAsesoria, infoAsesoria, estado}) {

 

    return (

  
      <div>
        <div class= "container">
          
          <div className='one'>
            <ImCross onClick={estado} className='close'> </ImCross>      
            <p className= "titulo">Asesoria del { infoAsesoria['5'].numeroDia} de  {infoAsesoria['5'].mes} </p> 
          </div>
  
          <div className='two'>
  
              <div className='subtitulo'>Hora: <p className='informacion'>{infoAsesoria['5'].asesorias[0].hora}</p> </div>
              <div className='subtitulo'>Asesor: <p className='informacion'>{infoAsesoria['5'].asesorias[0].asesor}</p> </div> 
              <div className='subtitulo'>Asesorado: <p className='informacion'>{infoAsesoria['5'].asesorias[0].asesorado}</p> </div> 
              <div className='subtitulo'>Lugar: <p className='informacion'>{infoAsesoria['5'].asesorias[0].lugar}</p> </div>           
              <div className='subtitulo'>Unidad de formacion: <p className='informacion'>{infoAsesoria['5'].asesorias[0].uF}</p> </div>
              <div className='subtitulo'>Duda: <p className='informacion'>{infoAsesoria['5'].asesorias[0].duda}</p> </div>
            
                 
          </div>

          <div>
            <p className='subtitulo'>Imágenes adjuntadas:</p>
          </div>
  
          <div className='three'>

       {infoAsesoria['5'].asesorias[0].images.map((images, index) => {
              return <div><ImagenAsesoria
              allowClosed = '0'
              size = 'reducida'
              source = {infoAsesoria['5'].asesorias[0].images[index]}
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
  

import React from 'react'
import './infoAsesorias.css';
import { ImCross } from 'react-icons/im';

import { BotonSencillo }  from '../../../routeIndex'
import { ImagenAsesoria, dateFunctions } from '../../../routeIndex'



export default function PopUpInformacionAsesoria({userTypePopUpAsesoria, infoAsesoria, estado}) {

 

    return (

  
      <div>
        <div class= "container">
          
          <div className='one'>
            <ImCross onClick={estado} className='close'> </ImCross>      
            <p className= "titulo">Asesoria del {infoAsesoria.dia} de {dateFunctions.getMonthEspanol(infoAsesoria.mes)} del {infoAsesoria.anio} </p> 
          </div>
  
          <div className='two'>
  
              <div className='subtitulo'>Hora: <p className='informacion'>{infoAsesoria.hora}</p> </div>
              <div className='subtitulo'>Asesor: <p className='informacion'>{(localStorage.rolUsuario === 'asesor') ? localStorage.usuario : infoAsesoria.usuario}</p> </div> 
              <div className='subtitulo'>Asesorado: <p className='informacion'>{(localStorage.rolUsuario === 'asesor') ? infoAsesoria.usuario : localStorage.usuario}</p> </div> 
              <div className='subtitulo'>Lugar: <p className='informacion'>{infoAsesoria.lugar}</p> </div>           
              <div className='subtitulo'>Unidad de formacion: <p className='informacion'>{infoAsesoria.uF}</p> </div>
              <div className='subtitulo'>Duda: <p className='informacion'>{infoAsesoria.duda}</p> </div>
            
                 
          </div>

          <div>
            <p className='subtitulo'>Imágenes adjuntadas:</p>
          </div>
  
          <div className='three'>

       {
        (infoAsesoria.hasOwnProperty('images'))
          ?
            infoAsesoria.images.map((img, index) => {
              return <div><ImagenAsesoria
              allowClosed = '0'
              size = 'reducida'
              source = {infoAsesoria.images[index]}
              alt = 'Debian'
              nameDownloadImage = 'La imagen de Debian'
              > </ImagenAsesoria> </div>
            })
          : <p></p>
       
       }   
          

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
  

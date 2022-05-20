import React from 'react'
import {BotonSencillo} from '../../../routeIndex';

import './popUpEncuesta.css';


const PopUpEncuesta = () => {

    const btnNoLlegada = () => {
        window.alert("no llegó el asesor/ado");
    }

  return (
    <>
        <div className='fondo-display-PopUpEncuesta-responder'>
            <div className='contenedor-encuesta'>
                <div className='encabezado-contenedor-encuesta'>

                    <div className='encabezado-izq-encuesta'>
                        <p className='encabezado-izq-encuesta-texto'>
                            Encuesta de experiencia y mejora de asesoria con Daniel Maldonado
                        </p>
                    </div>
                    <div className='encabezado-der-encuesta'>
                        <button 
                        onClick={ btnNoLlegada } 
                        className='btn-encabezado-encuesta'
                        >
                            No llegó el asesor
                        </button>
                    </div>
                    
                </div>
                <div className='contenido-contenedor-encuesta'>

                </div>
            </div>
        </div>


    </>
  )
}

export default PopUpEncuesta
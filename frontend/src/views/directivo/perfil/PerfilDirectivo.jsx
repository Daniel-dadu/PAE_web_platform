import React from 'react'

import './PerfilDirectivo.css'

import { Template, BotonConImagen, InformacionPersonalUsuario, BotonSencillo } from '../../../routeIndex'

import { BsBoxArrowInRight } from 'react-icons/bs'

function PerfilDirectivo() {
  return (

    <div>

        <Template>

        <div className='btn_PerfilCommon'>

            <h1> Perfil </h1>

        <div className='botonCerrarSesion' >
             <BotonConImagen 
                onClick={'Hola'} 
                backgroundColor='grisClaro'
                size="grande" 
                Image={BsBoxArrowInRight} >
                Cerrar Sesión
            </BotonConImagen>
        </div>

        </div>

            <div className='boxPerfilCommon'>
                <InformacionPersonalUsuario></InformacionPersonalUsuario>
            </div>

            <div className='btonDescargarEstadiPerfilDirectivo'>
            <BotonSencillo
            onClick={'Hola'}
            backgroundColor='verde'
            size='grande'>
            Descargar Estadisticas Generales
            </BotonSencillo>
            </div>

        </Template>

    </div>
    
  )
}

export default PerfilDirectivo
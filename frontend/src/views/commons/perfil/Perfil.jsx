import React from 'react'

import { Template, BotonConImagen, InformacionPersonalUsuario } from '../../../routeIndex'

import { BsBoxArrowInRight } from 'react-icons/bs'

import './Perfil.css'

function Perfil() {
  return (
    <div>

        <Template>

        <div className='btn_PerfilCommon'>

            <h1> Notificaciones </h1>

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

        </Template>

    </div>
  )
}

export default Perfil
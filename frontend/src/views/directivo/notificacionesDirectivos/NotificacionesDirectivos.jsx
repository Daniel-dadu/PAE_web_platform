import React from 'react'

import './NotificacionesDirectivos.css'
import { BiImageAdd } from 'react-icons/bi'

import { PanelNotificaciones, BotonConImagen } from '../../../routeIndex'

function NotificacionesDirectivos() {
  return (

    <PanelNotificaciones>

    <BotonConImagen 
        onClick={alert('No se permite subir más de 1 imagen')} 
        backgroundColor="azulCielo" 
        size="largo" 
        Image={BiImageAdd} >
            Subir imagen
        </BotonConImagen>

    </PanelNotificaciones>
  )
}

export default NotificacionesDirectivos
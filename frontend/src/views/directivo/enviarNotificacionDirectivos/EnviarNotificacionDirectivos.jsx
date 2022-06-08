import React from 'react';
import { Template, BotonSencillo, CampoTextoMenuDesplegable } from '../../../routeIndex';
import './enviarNotificacionesDirectivos.css'

var pruebaUsuariosJSON = {
    "usuarios": [
      {
        "claveUF":"A01734172",
        "colorTipo3":"gris_tipo_1",
        "horaAsesoria":"Ezequiel",
        "contenido":"Lozano"
      },
      {
        "claveUF":"A01734172",
        "colorTipo3":"gris_tipo_1",
        "horaAsesoria":"Ezequiel",
        "contenido":"Lozano"
      },
      {
        "claveUF":"A01734172",
        "colorTipo3":"gris_tipo_1",
        "horaAsesoria":"Ezequiel",
        "contenido":"Lozano"
      },
      {
        "claveUF":"A01734172",
        "colorTipo3":"gris_tipo_1",
        "horaAsesoria":"Ezequiel",
        "contenido":"Lozano"
      }
    ]
  }

const EnviarNotificacionDirectivos = () => {
    return (
        <>
            <Template view="notificaciones" >
                <div className='encabezado-enviarNotificacionesDir'>
                    <h1 className='texto-encabezado-enviarNotificacionesDir'>Enviar Notificación</h1>
                </div>

                <div className='contenedor-contenido-enviarNotificacionDirectivos'>
                    <div className='contenedor-para-enviarNotificacionDirectivos'>
                        <p className='texto-contenedor-para'> Para </p>
                        <CampoTextoMenuDesplegable usuariosJSON={ pruebaUsuariosJSON } />
                    </div>

                    <div className='contenedor-asunto-enviarNotificacionesDir'>
                        <p className='texto-contenedor-asunto'> Asunto </p>
                        <input type="text" name="asunto" id="asunto_envNotificaciones" />
                    </div>
                    <div className='contenedor-mensaje-enviarNotificacionesDir'>
                        <p className='texto-contenedor-mensaje'>Mensaje</p>
                        <textarea  id='mensaje_envNotificaciones'  ></textarea>
                    </div>
                </div>

                <div className='contenedor-botones-enviarNotificacionDirectivos'>
                    <BotonSencillo backgroundColor="gris" size="normal" children="Cancelar" onClick={"cancelar"}/>
                    <BotonSencillo backgroundColor="turquesa" size="normal" children="Enviar" onClick={"Enviar"} />

                </div>
            </Template>
        </>
    )
}

export default EnviarNotificacionDirectivos
import React, {useState} from 'react';
import { useNavigate } from "react-router-dom";
import { Template, BotonSencillo, CampoTextoMenuDesplegable } from '../../../routeIndex';
import './enviarNotificacionesDirectivos.css'

import axios from 'axios';

const EnviarNotificacionDirectivos = () => {
  
    let navigate = useNavigate();
    const routeChange = route => navigate(`/${route}`);
    const [currentSelection, setCurrentSelection] = useState('TODOS');
    const [asunto, setAsunto] = useState('');
    const [mensaje, setMensaje] = useState('');

    const onSelectGroup = (grupo) => {
      setCurrentSelection(grupo)
      
    }
    const enviarNoti = () => {

      var config = {
        method: 'post',
        url: 'http://20.225.209.57:3030/notificacion/enviarNotificacion_directivos',
        headers: { 
            'Content-Type': 'application/json'
        },
        data: JSON.stringify({
            "destinatario": currentSelection,
            "asunto": asunto,
            "mensaje": mensaje
        })
      };
      
      axios(config)
      .then(function (response) {
        alert(response.data);
      })
      .catch(function (error) {
        console.log(error);
      })

    }

    return (
        <>
            <Template view="notificaciones" >
                <div className='encabezado-enviarNotificacionesDir'>
                    <h1 className='texto-encabezado-enviarNotificacionesDir'>Enviar Notificación</h1>
                </div>

                <div className='contenedor-contenido-enviarNotificacionDirectivos'>
                    <div className='contenedor-para-enviarNotificacionDirectivos'>
                        <p className='texto-contenedor-para'> Para </p>
                        <CampoTextoMenuDesplegable getGroup = {onSelectGroup}/>
                    </div>

                    <div className='contenedor-asunto-enviarNotificacionesDir'>
                        <p className='texto-contenedor-asunto'> Asunto </p>
                        <input type="text" name="asunto" id="asunto_envNotificaciones" onChange = {t => setAsunto(t.target.value)}/>
                    </div>
                    <div className='contenedor-mensaje-enviarNotificacionesDir'>
                        <p className='texto-contenedor-mensaje'>Mensaje</p>
                        <textarea  id='mensaje_envNotificaciones' onChange = {t => setMensaje(t.target.value)}></textarea>
                    </div>
                </div>

                <div className='contenedor-botones-enviarNotificacionDirectivos'>
                    <BotonSencillo backgroundColor="gris" size="normal" children="Cancelar" onClick={() => routeChange("./notificaciones")}/>
                    <BotonSencillo backgroundColor="turquesa" size="normal" children="Enviar" onClick={enviarNoti} />

                </div>
            </Template>
        </>
    )
}

export default EnviarNotificacionDirectivos
import React from 'react'
import '../../../index.css'
import './Notificacion.css'

// Atributos de una notificación
// onClick = {() => {alert('Debo abrir el panel para aceptar la asesoria; ESTO APLICA EN LA PANTALLA DE DIRECTIVOS')}}
//   // Este parámetro solo debe usarse para las notificaciones de los directivos,
//   // específicamente en la notificación para ACEPTAR una asesoría.
// color = 'verde'
//   // verde
//   // rojo
//   // azul
// titulo = 'Mensaje de PAE:'
// leyenda = '11:00 PM — 4:00 AM'
// contenido = 'Tenemos reunión general el día lunes 30 de febrero en casa de Boba a las 9 pm. Vengan con toda la actitud para pasarla bien :)'

const Notificacion = ({
    onClick,
    color,
        // rojo
        // verde
        // azul
    titulo,
    leyenda,
    contenido
}) => {

    return(
        <div
            className = {`divNotificacion ${color}BordeNotificacion`}
            onClick = {onClick}
        >
            <div className = {`estadoNotificacion ${color}Notificacion`}> </div>
            <p className = 'tituloNotificacion'> {titulo} </p>
            <p className = 'leyendaNotificacion'> {leyenda} </p>
            <p className = 'contenidoNotificacion'> {contenido} </p>
        </div>
    );

};

export default Notificacion
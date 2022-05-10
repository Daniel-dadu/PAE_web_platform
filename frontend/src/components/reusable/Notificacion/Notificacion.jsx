import React from 'react'
import '../../../index.css'
import './Notificacion.css'

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
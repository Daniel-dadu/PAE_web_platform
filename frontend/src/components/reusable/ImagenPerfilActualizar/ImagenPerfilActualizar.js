import React from 'react'
import './ImagenPerfilActualizar.css'
const ImagenPerfilActualizar = ({ link, actualizar, aparecerTexto2, desaparecerTexto2 }) => {
  return (
    <>
        <img src={ link } alt="ImagenPerfil" className='imagen-InfPerUsuario' />
        <div
            className='display-img-editar'
            onClick={ () => actualizar }
            onMouseEnter={ aparecerTexto2 }
            onMouseLeave={ desaparecerTexto2 }>
            <p
                className='texto-display-img-editar'
                id='texto-display-img-editar' >
                Cambiar Imágen 2
            </p>

        </div>

        <p>Holaaa</p>        
    </>
  )
}

export default ImagenPerfilActualizar
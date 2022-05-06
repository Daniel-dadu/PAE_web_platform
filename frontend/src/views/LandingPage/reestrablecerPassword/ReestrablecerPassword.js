import React from 'react';
import './reestablecerPassword.css';

const ReestrablecerPassword = () => {
  return (
    <>
         <div className='contenedorGeneral'>
            <div className='izq'>
                <form action="" className='form-reestablecerPassword'>
                    <div className='contenedor-titulo-reestablecerPassword'>
                        <h1 className='reestablecerPassword-titulo'>Reestablecer Contraseña</h1>
                    </div>
                    
                    <div className='contenedor-textboxes'>
                        <div>
                            <p className='label-password'>Nueva Contraseña: </p>
                            <input type="password" name="" id="input-password" />

                        </div>
                        <div>
                            <p className='label-password'>Confirmar nueva contraseña: </p>
                            <input type="password" name="" id="input-password-confirmacion" />
                        </div>
                    </div>

                    <div className='contenedor-btn'>
                        <button className='boton-submit'>
                            Cambiar
                        </button>
                        <a href="#" className='volver-login'>Volver a Login</a>
                    </div>
                    
                </form>
            </div>
            <div className='der'>
                <img className='img-reestablecer-password' src= { require('../../../assets/reestablecerPassword.png') } alt="" />
            </div>
        </div>
    </>
  )
}

export default ReestrablecerPassword
import React from 'react';
import './recuperarPassword.css';

const RecuperarPassword = () => {
  return (
    <>
        <div className='contenedorGeneral'>
            <div className='izq'>
                <form action="" className='form-recuperarPassword'>
                    <div className='contenedor-titulo-recuperarpassword'>
                        <h1 className='recuperarPassword-titulo'>Recuperar Contraseña</h1>
                    </div>
                    
                    <div className='contenedor-textbox'>
                        <p className='label-email'>Escribe tu email institucional: </p>
                        <input type="email" name="" id="input-email" />
                    </div>

                    <div className='contenedor-btn'>
                        <button className='boton-submit'>
                            Enviar
                        </button>
                        <a href="#" className='volver-login'>Volver a Login</a>
                    </div>
                    
                </form>
            </div>
            <div className='der'>
                <img className='img-recuperar-password' src= { require('../../../assets/recuperarPassword.png') } alt="" />
            </div>
        </div>
    </>
  )
}

export default RecuperarPassword
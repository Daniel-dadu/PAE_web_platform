import React from 'react';
import './recuperarPassword.css';

const RecuperarPassword = () => {
  return (
    <>
        <div className='contenedorGeneral'>
            <div className='izq'>
                <form action="" className='form-recuperarPassword'>
                    <div className='titulo'>
                        <h1>Recuperar Contraseña</h1>
                    </div>
                    
                    <div className='contenedor-textbox'>
                        <p>Escribe tu email institucional: </p>
                        <input type="email" name="" id="" />
                    </div>

                    <div className='contenedor-btn'>
                        <button className='boton-submit'>
                            Enviar
                        </button>
                        <a href="#">Volver a la página de inicio</a>
                    </div>
                    
                </form>
            </div>
            <div className='der'>
                <img src= { require('../../../assets/recuperarPassword.png') } alt="" />
            </div>
        </div>
    </>
  )
}

export default RecuperarPassword
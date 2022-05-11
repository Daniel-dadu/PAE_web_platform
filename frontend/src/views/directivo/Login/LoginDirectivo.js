import React from 'react';
import './loginDirectivo.css';

const LoginDirectivo = () => {
  return (
    <>
        <section className={`contenedor-login-directivo`}>

            <div className='contenedor-principal-directivo'>
                <h1>Inicio de Sesión</h1>

                <form className='contenedor-inputs'>

                
                    <div className='contenedor-textbox'>
                        <p>Matricula</p>
                        <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"/>
                    </div>

                    <div className='contenedor-textbox'>
                        <p>Contraseña</p>
                        <input type="password" id="inputPassword5" class="form-control" aria-describedby="passwordHelpBlock"/>
                        <div className='contenedor-olv-contra'>
                            <a href='../recuperarPassword/RecuperarPassword.js'> ¿Olvidaste tu constraseña? </a>
                        </div>
                    </div>

                    <div className='contenedor-boton'>
                        <button> Ingresar </button>
                        
                    </div>


                </form>
            </div>
        </section>
    </>
  )
}

export default LoginDirectivo
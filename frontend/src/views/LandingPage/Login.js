import React from 'react';
import './login.css';



const Login = () => {
  return (
    <>
        <section className='contenedor-login'>
            <div className='contenedor-principal'>
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
                            <a href='#'> ¿Olvidaste tu constraseña? </a>
                        </div>
                    </div>

                


                    <div className='contenedor-boton'>
                        <button> Ingresar </button>
                        <a href='#'>¿No tienes cuenta?</a>
                    </div>
                </form>
            </div>
        </section>
    </>
  )
}

export default Login
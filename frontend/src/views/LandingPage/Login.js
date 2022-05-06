import React, { useState } from 'react';
import './login.css';
import { FaAngleDoubleRight, FaSignInAlt, FaInfoCircle } from 'react-icons/fa';


const Login = () => {

    const [clicked, setclicked] = useState(false);

    const handleClickLogin = () => {
        setclicked(!clicked);
    }

  return (
    <>
        <section className={`contenedor-login${ clicked ? ' active-login':''}`}>

            <div className='lateral-responsive'>
                <FaInfoCircle className='icono1' onClick={ handleClickLogin }/>

            </div>

            <div className='lateral-fuera-responsive'>
                <FaSignInAlt className='icono2' onClick={ handleClickLogin }/>
            </div>

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
                            <a href='./RecuperarPassword'> ¿Olvidaste tu constraseña? </a>
                        </div>
                    </div>

                


                    <div className='contenedor-boton'>
                        <button id='btn-login-asesorado'> <a href='./calendario'> Ingresar </a>  </button>
                        <a href='#'>¿No tienes cuenta?</a>
                    </div>
                </form>
            </div>
        </section>
    </>
  )
}

export default Login
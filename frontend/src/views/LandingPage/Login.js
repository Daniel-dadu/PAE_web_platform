import React, { useState } from 'react';
import { useNavigate } from "react-router-dom";
import axios from 'axios'
import './login.css';
import { FaSignInAlt, FaInfoCircle } from 'react-icons/fa';


const Login = () => {

    let navigate = useNavigate() // Hook para navegar a otra ruta

    const [clicked, setclicked] = useState(false);

    const handleClickLogin = () => {
        setclicked(!clicked);
    }

    /* Código de Daniel Maldonado */

    // Hooks para guardar en estas variables los datos que ingresa el usuario en los inputs
    const [matricula, setMatricula] = useState("");
    const [contrasena, setContrasena] = useState("");

    // Función que se ejecuta al darle click al botón de ingresar
    const handleSubmit = async e => {
        e.preventDefault()

        // Características de petición a la API
        let config = {
            method: 'put',
            url: 'http://20.225.209.57:3095/login/validate',
            headers: { 
                'Content-Type': 'application/json'
            },
            data: JSON.stringify({
                "user": matricula,
                "password": contrasena
            })
        }

        // Variables para guardar las respuestas de la API
        let usuario = "noUser"
        let apiError = null

         // Se realiza la consulta a la api en un try catch para manejar errores
        try {
            // Se pide la consulta a la API exigiendo que se ejecute la promesa en ese momento
            const response = await axios(config)
            usuario = { matricula, rolUsuario: response.data.rolUsuario }
        } catch (error) {
            apiError = error.response.data
        } 

        // Si se ingresaron datos incorrectos, se le indica al usuario
        if(apiError) {
            alert(apiError.ERROR === 'invalid userID' ? 
                "Error: No existe un usuario con esa matrícula" : 
                "Error: Contraseña incorrecta"
            )
        } else {
            // Si la petición funcionó adecuadamente, guardamos los datos del usuario en el localStorage
            localStorage.setItem("userInfo", JSON.stringify(usuario))
            navigate('/calendario') // ... y redirigimos al usuario al calendario
        }

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
                        <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" onChange={({ target }) => setMatricula(target.value)}/>
                    </div>

                    <div className='contenedor-textbox'>
                        <p>Contraseña</p>
                        <input type="password" id="inputPassword5" class="form-control" aria-describedby="passwordHelpBlock" onChange={({ target }) => setContrasena(target.value)}/>
                        <div className='contenedor-olv-contra'>
                            <a href='./RecuperarPassword'> ¿Olvidaste tu constraseña? </a>
                        </div>
                    </div>

                


                    <div className='contenedor-boton'>
                        {/* <button id='btn-login-asesorado'> <a href='./calendario'> Ingresar </a>  </button> */}
                        <button id='btn-login-asesorado' onClick={handleSubmit}> Ingresar </button>
                        <a href='#'>¿No tienes cuenta?</a>
                    </div>

                </form>
            </div>
        </section>
    </>
  )
}

export default Login
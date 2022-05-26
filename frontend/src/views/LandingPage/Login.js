import React, { useState } from 'react';
import { useNavigate } from "react-router-dom";
import axios from 'axios'
import './login.css';

import { FaSignInAlt, FaInfoCircle } from 'react-icons/fa';
import noUserImg from '../../assets/noUserImg.png'


const Login = () => {

    let navigate = useNavigate() // Hook para navegar a otra ruta

    const [clicked, setclicked] = useState(false);

    const handleClickLogin = () => {
        setclicked(!clicked);
    }

    /* Código de Daniel Maldonado */

    // Hooks para guardar en estas variables los datos que ingresa el usuario en los inputs
    const [logged, setLogged] = useState(localStorage.usuario)

    const logout = () => {
        setLogged(null)
        localStorage.clear()
    }

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
            usuario = { 
                matricula, 
                rol: response.data.rol_user, 
                foto: response.data.foto_user,
                modo: response.data.modo_user,
                idioma: response.data.idioma_user
            }
        } catch (error) {
            apiError = error.response.data || "undefined"
        } 

        // Si se ingresaron datos incorrectos, se le indica al usuario
        if(apiError) {
            alert(apiError === "undefined" ? 'Error: Intente más tarde (API error)' : 
                apiError.ERROR === 'invalid userID' ? 
                "Error: No existe un usuario con esa matrícula" : 
                "Error: Contraseña incorrecta"
            )
        } else {
            // Si la petición funcionó adecuadamente, guardamos los datos del usuario en el localStorage
            localStorage.setItem("usuario", usuario.matricula)
            localStorage.setItem("rolUsuario", usuario.rol)
            localStorage.setItem("fotoUsuario", usuario.foto)
            localStorage.setItem("modo", usuario.modo)
            localStorage.setItem("idioma", usuario.idioma)
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

                
                    {
                    logged ? 
                    <div>
                        <p className='logged-paragraph'>Ya iniciaste sesión</p>
                        <img src={localStorage.fotoUsuario.length < 20 ? noUserImg : localStorage.fotoUsuario} alt="Perfil" className={'profile-img-login'} />
                        <p className='logged-user'>{localStorage.usuario}</p>
                        <button className='btn-login-ingresar logged-btn-align' onClick={() => navigate('/calendario')}>Ingresar</button>
                        <br />
                        <button className='btn-login-ingresar btn-login-cerrarsesion logged-btn-align' onClick={() => logout()}>Cerrar sesión</button>
                    </div>
                    :
                    <form className='contenedor-inputs'>

                        <div className='contenedor-textbox'>
                            <p>Matricula</p>
                            <input type="email" className="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" onChange={({ target }) => setMatricula(target.value)}/>
                        </div>

                        <div className='contenedor-textbox'>
                            <p>Contraseña</p>
                            <input type="password" id="inputPassword5" className="form-control" aria-describedby="passwordHelpBlock" onChange={({ target }) => setContrasena(target.value)}/>
                            <div className='contenedor-olv-contra'>
                                <a href='./RecuperarPassword'> ¿Olvidaste tu constraseña? </a>
                            </div>
                        </div>

                        <div className='contenedor-boton'>
                            <button className='btn-login-ingresar' onClick={handleSubmit}> Ingresar </button>
                            <a href='/registroAsesoradoDatos'>¿No tienes cuenta?</a>
                        </div>
                        
                    </form>
                    }

            </div>

        </section>
            
    </>
  )
}

export default Login
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
            localStorage.setItem("userInfo", JSON.stringify(usuario))
            navigate('/calendario') // ... y redirigimos al usuario al calendario
        }

    }


    const imageCompressor = () => {
        console.log('Downloading lorem ipsum image to simulate a file from user input')

        fetch('https://picsum.photos/1920/1080/?random')
        .then(res => res.blob())
        .then(blob => {
        const img = new Image()
        img.src = URL.createObjectURL(blob)

        console.log(`Original image size (at 1920x1080) is: ${blob.size} bytes`)
        console.log('URL to original image:', img.src)
        
        img.onload = () => resize(img, 'jpeg').then(blob => {
            console.log('Final blob size', blob.size)
            console.log('Final blob url:', URL.createObjectURL(blob))

            var reader = new FileReader();
            reader.readAsDataURL(blob); 
            reader.onloadend = function() {
                var base64data = reader.result;                
                console.log('Final blob 1:', base64data);
            }
            
            console.log('\nNow with webp\n')
            
            resize(img, 'webp').then(blob => {
                console.log('Final blob size', blob.size)
                console.log('Final blob url:', URL.createObjectURL(blob))

                reader = new FileReader();
                reader.readAsDataURL(blob); 
                reader.onloadend = function() {
                    var base64data = reader.result;                
                    console.log('Final blob 1:', base64data);
                }
            })
        })
        })

        const MAX_WIDTH = 1280
        const MAX_HEIGHT = 720
        const MAX_SIZE = 100000 // 100kb

        async function resize(img, type = 'jpeg') {
        const canvas = document.createElement('canvas')
        const ctx = canvas.getContext('2d')
        
        ctx.drawImage(img, 0, 0)
        
        let width = img.width
        let height = img.height
        let start = 0
        let end = 1
        let last, accepted, blob
        
        // keep portration
        if (width > height) {
            if (width > MAX_WIDTH) {
            height *= MAX_WIDTH / width
            width = MAX_WIDTH
            }
        } else {
            if (height > MAX_HEIGHT) {
            width *= MAX_HEIGHT / height
            height = MAX_HEIGHT
            }
        }
        canvas.width = width
        canvas.height = height
        console.log('Scaling image down to max 1280x720 while keeping aspect ratio')
        ctx.drawImage(img, 0, 0, width, height)
        
        accepted = blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, 1))
        
        if (blob.size < MAX_SIZE) {
            console.log('No quality change needed')
            return blob
        } else {
            console.log(`Image size after scaling ${blob.size} bytes`)
            console.log('Image sample after resizeing with losseless compression:', URL.createObjectURL(blob))
        }
        
        // Binary search for the right size
        while (true) {
            const mid = Math.round( ((start + end) / 2) * 100 ) / 100
            if (mid === last) break
            last = mid
            blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, mid))
                console.log(`Quality set to ${mid} gave a Blob size of ${blob.size} bytes`)
            if (blob.size > MAX_SIZE) { end = mid }
            if (blob.size < MAX_SIZE) { start = mid; accepted = blob }
        }

        return accepted
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
            
            <div>
                <button onClick={imageCompressor}> imageCompressor </button>
            </div>

            </div>

        </section>
            
    </>
  )
}

export default Login
import React, { useState } from 'react'
import './recuperarPassword.css'

import axios from 'axios'
import useScript from '../../../hooks/useScript.js';
import { useNavigate } from 'react-router-dom';


const RecuperarPassword = () => {

    const navigate = useNavigate()

    const [InputMatricula, setInputMatricula] = useState('')

    // Importamos el script para enviar correos
    useScript('https://smtpjs.com/v3/smtp.js')

    const sendEmail = async (destinatario, titulo, contenido) => {
        return await window.Email.send({
            SecureToken : "d852b9c0-032f-44da-a2b3-6769984428b2",
            To : destinatario,
            From : "paetecpuebla@gmail.com",
            Subject : titulo,
            Body : contenido
        })
    }

    const [correoSended, setCorreoSended] = useState(false)

    const onEnviarCorreo = () => {

        if(InputMatricula.length < 9) alert("La matrícula debe tener 9 caracteres")
        else {

            const config = {
                method: 'get',
                url: `http://20.225.209.57:3095/login/get_hash_user/?matricula=${InputMatricula}`,
                headers: { }
            }
            
            axios(config)
            .then(async response => {
                const hashUser = response.data
                const resultEmail = await sendEmail(
                    `${InputMatricula}@tec.mx`, 
                    'Restablecer contraseña para el acceso a la plataforma de PAE', 
                    // -------- IMPORTANTE: CAMBIAR EL DOMINIO DEL LINK DE ABAJO: --------// 
                    `Para restablecer tu contraseña, ingresa a este link: http://20.225.209.57/reestablecerContrasena/${InputMatricula}/${hashUser}`
                )
                if(resultEmail === 'OK') {
                    setCorreoSended(true)
                } else {
                    alert("Error: no se pudo enviar el correo, intente de nuevo más tarde.")
                    navigate('/landingPage')
                }
            })
            .catch(_error => {
                alert("Error: Ese usuario no está registrado en el sistema.\nVerifica que tu matrícula esté escrita correctamente.")
            })
        
        }

    }

    return (
        <div className='contenedorGeneral'>
            <div className='izq'>

                {
                    correoSended ? 
                    <div className='form-recuperarPassword'>
                        <div className='contenedor-titulo-recuperarpassword'>
                            <h1 className='recuperarPassword-titulo'>Recuperar Contraseña</h1>
                        </div>
                        <p style={{width: '80%', fontStyle: 'italic', textAlign: 'center', fontSize: '1.3rem'}}>
                            Revisa tu correo institucional e ingresa al link que fue enviado para realizar el proceso de restablecer la contraseña de tu cuenta. 
                            <br />
                            <br />
                            En caso de no aparecer, revisa el correo no deseado o spam. 
                            <br />
                            <br />
                            Si después de 5 minutos definitivamente no aparece, repite el proceso de recuperar tu contraseña.
                        </p>
                        <div className='contenedor-btn'>
                            <a href="/landingPage" className='volver-login'>Volver a Login</a>
                        </div>
                    </div>
                    :
                    <div className='form-recuperarPassword'>
                        <div className='contenedor-titulo-recuperarpassword'>
                            <h1 className='recuperarPassword-titulo'>Recuperar Contraseña</h1>
                        </div>

                        <div className='contenedor-textbox'>
                            <p className='label-email'>Escribe tu matrícula: </p>
                            <input name="" id="input-email" onChange={t => setInputMatricula(t.target.value)} />
                        </div>

                        <p style={{width: '80%', fontStyle: 'italic', textAlign: 'center'}}>
                            Al darle click al botón de enviar, deberás entrar a tu correo institucional y dar click en el enlace que se envió para realizar el proceso de creación de una nueva contraseña.
                        </p>

                        <div className='contenedor-btn'>
                            <button className='boton-submit' onClick={onEnviarCorreo}>
                                Enviar
                            </button>
                            <a href="/landingPage" className='volver-login'>Volver a Login</a>
                        </div>
                    </div>
                }
                    
            </div>
            <div className='der'>
                <img className='img-recuperar-password' src= { require('../../../assets/recuperarPassword.png') } alt="" />
            </div>
        </div>
  )
}

export default RecuperarPassword
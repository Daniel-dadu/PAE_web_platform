import React, { useEffect, useState } from 'react'
import './reestablecerPassword.css'
import { CampoTextoPequeno } from '../../../routeIndex.js'

import axios from 'axios'
import { useNavigate, useParams } from 'react-router-dom'

const ReestrablecerPassword = () => {

    const navigate = useNavigate()

    const { matricula, hash } = useParams()

    useEffect(() => {

        const config = {
            method: 'get',
            url: `http://20.225.209.57:3095/login/get_hash_user/?matricula=${matricula}`,
            headers: { }
        }
        
        axios(config)
        .then(async response => {
            const hashUser = response.data
            if(hashUser === hash) {
                console.log("Todo bien")
            } else {
                alert("No tienes permiso para acceder a este recurso")
                navigate('/landingPage')
            }
        })
        .catch(_error => {
            alert("No se pudo obtener la información necesaria, intente más tarde")
            navigate('/landingPage')
        })


    }, [matricula, hash, navigate])

    const [contrasena, setContrasena] = useState('')
    const handleTextContrasena = textInserted => setContrasena(textInserted)
    const [contrasenaConfirm, setContrasenaConfirm] = useState('')
    const handleTextContrasenaConfirm = textInserted => setContrasenaConfirm(textInserted)

    return (
    <>
         <div className='contenedorGeneral'>
            <div className='izq'>
                <div className='form-reestablecerPassword'>
                    <div className='contenedor-titulo-reestablecerPassword'>
                        <h1 className='reestablecerPassword-titulo'>Reestablecer Contraseña</h1>
                    </div>

                    <p style={{width: '80%', fontStyle: 'italic', textAlign: 'center'}}>
                        Hola usuario con matrícula: {matricula}.
                        <br />
                        Para ingresa la nueva contraseña para tu cuenta.
                    </p>

                    <div className='contenedro_deInputsAsesoradoRegistro'> 
                        <div className='texto_contenedor_deInputsAsesoradoRegistro'> 
                            Nueva contraseña
                            { contrasena.length < 8 && <span className='input_incorrecto'>La contraseña debe tener al menos 8 caracteres</span> } 
                        </div>
                        <CampoTextoPequeno size="big" onInsertText={handleTextContrasena} isPassword={true}/>
                    </div>

                    <div className='contenedro_deInputsAsesoradoRegistro'> 
                        <div className='texto_contenedor_deInputsAsesoradoRegistro'> 
                            Nueva confirmar contraseña 
                            { contrasena !== contrasenaConfirm && <span className='input_incorrecto'>Las contraseñas no coinciden</span> } 
                        </div>
                        <CampoTextoPequeno size="big" onInsertText={handleTextContrasenaConfirm} isPassword={true} />
                    </div>

                    <div className='contenedor-btn'>
                        <button className='boton-submit'>
                            Cambiar
                        </button>
                        <a href="/landingPage" className='volver-login'>Volver a Login</a>
                    </div>
                    
                </div>
            </div>
            <div className='der'>
                <img className='img-reestablecer-password' src= { require('../../../assets/reestablecerPassword.png') } alt="" />
            </div>
        </div>
    </>
  )
}

export default ReestrablecerPassword
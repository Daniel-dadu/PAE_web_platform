import React, { useEffect } from 'react'

import { Template, BotonConImagen, InformacionPersonalUsuario } from '../../../routeIndex'

import { useNavigate } from 'react-router-dom'

import { BsBoxArrowInRight } from 'react-icons/bs'

import './Perfil.css'

function Perfil({ children }) {

    const navigate = useNavigate()
    
    // Verificamos que el usuario tenga la información de su perfil en el localStorage
    useEffect(() => {
        if(!localStorage.usuario || !localStorage.rolUsuario || !localStorage.fotoUsuario){
            localStorage.clear()
            navigate('/landingPage')
            return
        }
    }, [navigate])

    // Función que se ejecuta al dar click en el botón de cerrar sesión
    const onCerrarSesion = () => {
        localStorage.clear()
        alert("Se ha cerrado sesión correctamente")
        navigate('/landingPage')
    }

    return (

        <Template view="perfil">

            <div className='btn_PerfilCommon'>

                <h1> Perfil </h1>

                <div className='botonCerrarSesion' >
                    <BotonConImagen 
                    onClick={onCerrarSesion} 
                    backgroundColor='grisClaro'
                    size="normal" 
                    Image={BsBoxArrowInRight} >
                        Cerrar Sesión
                    </BotonConImagen>
                </div>

            </div>

            <div className='boxPerfilCommon'>
                <InformacionPersonalUsuario />
            </div>

            <div>
                {children}
            </div>

        </Template>

    )
}

export default Perfil
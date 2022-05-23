import React, { useEffect } from 'react'

import { TemplateRegistroUsuario } from '../../../routeIndex'

import { useNavigate } from "react-router-dom";

import noUserImg from '../../../assets/noUserImg.png'

let progressBar = {
    "currentStep": 2,
    "steps": [
        {
            "name" : "Datos Generales",
            "state": true,
            "next": "enable",
            "path" : "/registroAsesoradoDatos"
          }, 
          {
            "name" : "Consideraciones Finales",
            "state": true,
            "next": "enable",
            "path" : "./registroAsesoradoCondiciones"
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "Ruta"
          }
    ]
}

const RegistroAsesoradoResumen = () => {

    // En caso de que el usuario cierre la pestaña o se cambie a otra ruta, se eliminan los datos de la asesoría
    window.addEventListener("unload", () => {
        localStorage.removeItem('registro1_matricula')
        localStorage.removeItem('registro1_contrasena')
        localStorage.removeItem('registro1_nombre')
        localStorage.removeItem('registro1_apellidoPaterno')
        localStorage.removeItem('registro1_apellidoMaterno')
        localStorage.removeItem('registro1_carrera')
        localStorage.removeItem('registro1_telefono')
        localStorage.removeItem('registro1_imagenPerfil')
    })

    let navigate = useNavigate()

    const nombreUser = localStorage.registro1_nombre
    const apellidoPatUser = localStorage.registro1_apellidoPaterno
    const apellidoMatUser = localStorage.registro1_apellidoMaterno
    const matriculaUser = localStorage.registro1_matricula
    const carreraUser = localStorage.registro1_carrera
    const telefonoUser = localStorage.registro1_telefono
    const imagenUser = localStorage.registro1_imagenPerfil

    // Verificamos que se cuente con todos campos obligatorios
    // Si no, se envía al usuario a la landing page
    useEffect(() => {
        if(!nombreUser || !apellidoPatUser || !matriculaUser || !carreraUser) {
            localStorage.clear()
            navigate('/landingPage')
        }
    })

    return (
    
        <TemplateRegistroUsuario 
            progressBarJSON={progressBar}
            btnAtrasRoute ="./registroAsesoradoCondiciones"
            btnSiguienteProps={ 
                {
                    view: 3, 
                    props: { nombreUser, apellidoPatUser, apellidoMatUser, matriculaUser, carreraUser, telefonoUser, imagenUser }
                } 
            }
            ultimoTexto='Confirmar'>
            
            <div className='bloq_condicionesAsesorado'>
                <h1 className='campo_RegistroAsesoradoCondiciones'> Resumen de información </h1>
     
            </div>
            <div className='contenedor-general-InfPerUsuario'>
                <div className='contenedor-InfPerUsuario'>

                    <div className='contenedor-InfPerUsuario-izq' >

                        <div className='contenedor-img-perfil-InfPerUsuario'>

                            <img src={ imagenUser ? imagenUser : noUserImg } 
                                alt="imgProfile" 
                                className='imagen-InfPerUsuario'
                                style={{objectFit: 'cover'}}
                            />

                        </div>

                    </div>

                    <div className='contenedor-InfPerUsuario-der' >
                        
                        <p className='etiqueta-nombre-InfPerUsuario' >
                            { nombreUser + " " + apellidoPatUser }
                        </p>
                        <p className='etiqueta-matricula-InfPerUsuario' >{ matriculaUser }</p>

                        <p className={ 'etiqueta-carrera-InfPerUsuario' }  >
                            <span style={{fontWeight: '600'}}>Carrera: </span> 
                            { carreraUser ? carreraUser : null }
                        </p>
                        
                        <p className={ 'etiqueta-telefono-InfPerUsuario' }  >
                            <span style={{fontWeight: '600'}}>Teléfono: </span> 
                            { telefonoUser ? telefonoUser : 'No se ingresó' }
                        </p>

                    </div>

                </div>
            </div>
        </TemplateRegistroUsuario>
    )
}

export default RegistroAsesoradoResumen
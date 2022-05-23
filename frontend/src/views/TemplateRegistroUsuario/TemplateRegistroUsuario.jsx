import React, { useState } from 'react'
import '../../index.css'
import './TemplateRegistroUsuario.css'
import { BotonSencillo, TarjetaMaestra, BarraProgreso, imageCompressor } from '../../routeIndex'

import axios from 'axios'

import LoadingSpin from "react-loading-spin";

import { useNavigate } from "react-router-dom";

const TemplateRegistroUsuario = ({ progressBarJSON, children, btnAtrasRoute, btnSiguienteProps, ultimoTexto ="" }) => {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [loadingNext, setLoadingNext] = useState(false)
    
    // Función que se ejecutará siempre que se de click al botón de siguiente
    // Es asincrona ya que para comprimir las imágenes y crear las asesorías se requiere esperar por el resultado 
    const onSiguienteClick = async (data) => {

        // Ponemos la animación de carga
        setLoadingNext(true)

        let usr = data.props

        // Si hubo un error con la API
        if(usr === null) {
            navigate('/landingPage')
            setLoadingNext(false)
            return
        }

        if(data.view === 1) {

            // Validamos que se hayan llenado los campos obligatorios
            if (usr.nombre === '' || 
                usr.apellidoParterno === '' || 
                usr.matricula === '' || 
                usr.carrera === '' ||
                usr.contrasena === '' || 
                usr.contrasenaConfirm === '') {
                alert('No se han llenado todos los campos obligatorios')
                setLoadingNext(false)
                return
            } 
            // Validamos que la matrícula tenga 9 caracteres
            if (usr.matricula.length !== 9) {
                alert('La matrícula debe tener una longitud de 9 caracteres')
                setLoadingNext(false)
                return
            }
            // Validamos que la contraseña tenga como mínimo 8 caracteres
            if (usr.contrasena.length < 8) {
                alert('La contraseña debe tener al menos 8 caracteres')
                setLoadingNext(false)
                return
            }
            // Validamos que las contraseñas sean iguales
            if (usr.contrasena !== usr.contrasenaConfirm) {
                alert('Las contraseñas no coinciden')
                setLoadingNext(false)
                return
            }

            // Establecemos las variables en el localStorage
            localStorage.setItem('registro1_matricula', usr.matricula)
            localStorage.setItem('registro1_contrasena', usr.contrasena)
            localStorage.setItem('registro1_nombre', usr.nombre)
            localStorage.setItem('registro1_apellidoPaterno', usr.apellidoParterno)
            localStorage.setItem('registro1_carrera', usr.carrera.slice(0, usr.carrera.indexOf(" ")))

            // Eliminamos los campos no obligatorios en caso de que se hayan eliminado manuelmente al dar usar el btn Atras
            localStorage.removeItem('registro1_apellidoMaterno')
            localStorage.removeItem('registro1_telefono')
            localStorage.removeItem('registro1_imagenPerfil')

            // Verificamos los campos no obligatorios que haya ingresado el usuario y los guardamos 
            if(usr.apellidoMarterno) localStorage.setItem('registro1_apellidoMaterno', usr.apellidoMarterno)
            if(usr.telefono) localStorage.setItem('registro1_telefono', usr.telefono)
            
            if(usr.imageUploaded) {
                // Comprimimos la imagen de perfil
                let imageCompressed = await imageCompressor(usr.imageUploaded)
                // Si no se puede comprimir, se le indica al usuario
                if(imageCompressed.slice(0, 5) === "error"){
                    alert('Tu imagen es muy grande.\nReduce el tamaño y vuelve a intentarlo')
                    setLoadingNext(false)
                    return
                }
                localStorage.setItem('registro1_imagenPerfil', imageCompressed)
            } 

            // Navegamos a la siguiente pantalla
            navigate('/registroAsesoradoCondiciones')
        }

        else if(data.view === 2) {
            if(usr.userChecked) {
                navigate('/registroAsesoradoResumen')
            } else {
                alert('Es necesario que se acepten los términos y condiciones')
            }
        }

        else if (data.view === 3) {
            const matricula_confirmed = localStorage.registro1_matricula
            const contrasena_confirmed = localStorage.registro1_contrasena
            const nombre_confirmed = localStorage.registro1_nombre
            const apellidoPat_confirmed = localStorage.registro1_apellidoPaterno
            const apellidoMat_confirmed = localStorage.registro1_apellidoMaterno
            const carrera_confirmed = localStorage.registro1_carrera
            const telefono_confirmed = localStorage.registro1_telefono
            const imagenPerfil_confirmed = localStorage.registro1_imagenPerfil

            const config = {
                method: 'post',
                url: 'http://20.225.209.57:3090/registro/nuevo_asesorado',
                headers: { 
                    'Content-Type': 'application/json'
                },
                data: JSON.stringify({
                    "matricula": matricula_confirmed,
                    "contrasena": contrasena_confirmed,
                    "nombre": nombre_confirmed,
                    "apellidoPaterno": apellidoPat_confirmed,
                    "apellidoMaterno": apellidoMat_confirmed ? apellidoMat_confirmed : null,
                    "fotoPerfil": imagenPerfil_confirmed ? imagenPerfil_confirmed : null,
                    "telefono": telefono_confirmed ? telefono_confirmed : null,
                    "carrera": carrera_confirmed
                })
            }
            
            axios(config)
                .then(response => {
                    alert("Bien, " + response.data)
                    localStorage.clear()
                    navigate('/landingPage')
                })
                .catch(error => {
                    alert("Error: " + error.response.data)
                    navigate('/registroAsesoradoDatos')
                });
        }

        setLoadingNext(false)
    }
    
    return(
        <div className = 'container_templateRegistroUsuario'>

            <div className = 'header_templateRegistroUsuario'>
                <img src = {require(`../../assets/pae_logo.png`)} alt = 'Logo pae' className = 'imgHeader'/>
                <p className = 'txtHeader'> Registro </p>
            </div>

            <div className='registro_barraProgreso'>
                <BarraProgreso progress = {progressBarJSON}/>
            </div>

            <br />
            <div style={{height: '77%'}}>
                <TarjetaMaestra viewRegistro={true}>
                    {children}

                    <div className='container_navButtons_RegistroUsuario'>
                        <div className='.btn_right_registro'>
                            <BotonSencillo onClick = {typeof btnAtrasRoute === 'string' ? () => routeChange(btnAtrasRoute) : "accionConBackend"} backgroundColor='azulCielo' size='largo'>
                                Atras
                            </BotonSencillo>
                        </div> 
                        <div >
                        {
                            loadingNext ?
                            <div className='loading_spin'>
                                <LoadingSpin />
                            </div>
                            :
                            ultimoTexto === "" ?
                            <BotonSencillo onClick={() => onSiguienteClick(btnSiguienteProps)} backgroundColor='verde' size='largo'>
                                Siguiente
                            </BotonSencillo>
                            :
                            <BotonSencillo onClick={() => onSiguienteClick(btnSiguienteProps)} backgroundColor='verde' size='largo' children={ ultimoTexto } />
                        }
                        </div>
                </div>
                </TarjetaMaestra>
            </div>

        </div>
    );

};

export default TemplateRegistroUsuario
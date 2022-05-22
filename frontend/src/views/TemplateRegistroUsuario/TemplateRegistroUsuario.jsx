import React, { useState } from 'react'
import '../../index.css'
import './TemplateRegistroUsuario.css'
import { BotonSencillo, TarjetaMaestra, BarraProgreso, imageCompressor } from '../../routeIndex'

import LoadingSpin from "react-loading-spin";

import { useNavigate } from "react-router-dom";

const TemplateRegistroUsuario = ({ progressBarJSON, children, btnAtrasRoute, btnSiguienteProps, ultimoTexto ="" }) => {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [loadingNext, setLoadingNext] = useState(false)
    
    // Función que se ejecutará siempre que se de click al botón de siguiente
    // Es asincrona ya que para comprimir las imágenes y crear las asesorías se requiere esperar por el resultado 
    const onSiguienteClick = async (data) => {
        // Se entra en caso de que el botón se ejecute en la view 1 - AgendarAsesoriaUF
        let usr = data.props
        if(data.view === 1) {
            // Si hubo un error con la API
            if(usr === null) {
                navigate('/landingPage')
            } else if (usr.nombre === '' || usr.apellidoParterno === '' || usr.matricula === '' || usr.carrera === '') {
                // Si no llena alguno de los campos obligatorios, se le informa
                alert('No se han llenado todos los campos obligatorios')
                return
            } else {
                // Ponemos la animación de carga
                setLoadingNext(true)

                // Establecemos las variables en el localStorage
                localStorage.setItem('registro1_nombre', usr.nombre)
                localStorage.setItem('registro1_apellidoPaterno', usr.apellidoParterno)
                localStorage.setItem('registro1_matricula', usr.matricula)
                localStorage.setItem('registro1_carrera', usr.carrera)

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
        }

        setLoadingNext(false)
    }
    
    return(
        <>
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


        </>
    );

};

export default TemplateRegistroUsuario
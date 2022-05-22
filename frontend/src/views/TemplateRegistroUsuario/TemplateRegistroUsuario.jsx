import React from 'react'
import '../../index.css'
import './TemplateRegistroUsuario.css'
import {BotonSencillo, TarjetaMaestra, BarraProgreso } from '../../routeIndex'

import { useNavigate } from "react-router-dom";

const TemplateRegistroUsuario = ({ progressBarJSON, children, btnAtrasRoute, btnSiguienteProps, ultimoTexto ="" }) => {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);
    
    // Función que se ejecutará siempre que se de click al botón de siguiente
    // Es asincrona ya que para comprimir las imágenes y crear las asesorías se requiere esperar por el resultado 
    const onSiguienteClick = async (data) => {
        // Se entra en caso de que el botón se ejecute en la view 1 - AgendarAsesoriaUF
        if(data.view === 1) {
            // If the object doesn't have keys
            if(Object.keys(data.props).length === 0) {
                navigate('/landingPage')
            } else {
                console.log(data.props)
            }
        }
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
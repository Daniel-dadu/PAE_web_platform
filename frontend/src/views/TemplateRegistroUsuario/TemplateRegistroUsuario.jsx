import React from 'react'
import '../../index.css'
import './TemplateRegistroUsuario.css'
import {BotonSencillo, TarjetaMaestra, BarraProgreso } from '../../routeIndex'

import { useNavigate } from "react-router-dom";

const TemplateRegistroUsuario = ({
    progressBarJSON,
    children, showAtrasBtn, btnAtrasRoute, btnSiguienteRoute, ultimoTexto =""
}) => {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

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
                        (
                            <BotonSencillo onClick={typeof btnSiguienteRoute === 'string' ? () => routeChange(btnSiguienteRoute) : "accionConBackend"} backgroundColor='verde' size='largo'>
                                Siguiente
                            </BotonSencillo>
                        ):
                        (
                            <BotonSencillo onClick={typeof btnSiguienteRoute === 'string' ? () => routeChange(btnSiguienteRoute) : "accionConBackend"} backgroundColor='verde' size='largo' children={ ultimoTexto }>
                            </BotonSencillo>
                        )    
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
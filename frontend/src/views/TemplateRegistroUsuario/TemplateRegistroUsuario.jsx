import React from 'react'
import '../../index.css'
import './TemplateRegistroUsuario.css'
import {BotonSencillo, TarjetaMaestra, BarraProgreso } from '../../routeIndex'

import { useNavigate } from "react-router-dom";

const TemplateRegistroUsuario = ({
    progressBarJSON,
    children, showAtrasBtn, btnAtrasRoute, btnSiguienteRoute
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

            <BarraProgreso progress = {progressBarJSON}/>
            <br />
            <TarjetaMaestra>
                {children}

                <div className='container_navButtons_RegistroUsuario'>
            <div className='.btn_right_registro'>
                <BotonSencillo onClick = {typeof btnAtrasRoute === 'string' ? () => routeChange(btnAtrasRoute) : "accionConBackend"} backgroundColor='azulCielo' size='largo'>
                    Atras
                </BotonSencillo>
            </div> 
            <div >
                <BotonSencillo onClick={typeof btnSiguienteRoute === 'string' ? () => routeChange(btnSiguienteRoute) : "accionConBackend"} backgroundColor='verde' size='largo'>
                    Siguiente
                </BotonSencillo>
            </div>
        </div>
            </TarjetaMaestra>

        </div>


        </>
    );

};

export default TemplateRegistroUsuario
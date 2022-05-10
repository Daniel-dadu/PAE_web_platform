import React from 'react'
import '../../index.css'
import './TemplateRegistroUsuario.css'
import { TarjetaMaestra, BarraProgreso } from '../../routeIndex'

const TemplateRegistroUsuario = ({
    progressBarJSON,
    children
}) => {

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
            </TarjetaMaestra>

        </div>
        </>
    );

};

export default TemplateRegistroUsuario
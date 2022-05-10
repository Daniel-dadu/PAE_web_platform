import React from 'react'
import '../../index.css'
import './TemplateRegistroUsuario.css'
import { TarjetaMaestra } from '../../routeIndex'

const TemplateRegistroUsuario = ({
    children
}) => {

    return(
        <>
        <div className = 'container_templateRegistroUsuario'>

            <div className = 'header_templateRegistroUsuario'>
                <img src = {require(`../../assets/pae_logo.png`)} alt = 'Logo pae' className = 'imgHeader'/>
                <p className = 'txtHeader'> Registro </p>
            </div>

            <TarjetaMaestra>
                {children}
            </TarjetaMaestra>

        </div>
        </>
    );

};

export default TemplateRegistroUsuario
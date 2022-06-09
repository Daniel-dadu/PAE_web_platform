import React from 'react'
import './AdministrarPerfil.css'

import { Template, InformacionPersonalUsuario, BotonSencillo } from '../../../routeIndex';
import { useNavigate, useParams } from 'react-router-dom';

function AdministrarPerfil() {

    const navigate = useNavigate()

    const { rol, iduser } = useParams();

    return (
        <Template view='perfil'>

            <div className='btn_PerfilCommon'>

                <h1> Editar perfil de {rol} </h1>

            </div>

            <div className='boxPerfilCommon'>
                <InformacionPersonalUsuario idUserParam={iduser} rolUserParam={rol} />
            </div>

            <div className = 'btnAtras'>
                <BotonSencillo
                    onClick = {() => navigate(rol === 'asesor' ? "/administrarAsesores" : rol === 'asesorado' ? "/administrarAsesorados" : "/administrarDirectivos")}
                    backgroundColor = 'turquesa'
                    size = 'normal'
                >
                    Atrás
                </BotonSencillo>
            </div>

        </Template>
    )
}

export default AdministrarPerfil
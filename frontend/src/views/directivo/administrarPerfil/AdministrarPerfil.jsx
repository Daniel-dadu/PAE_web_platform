import React from 'react'
import './AdministrarPerfil.css'

import { Template, InformacionPersonalUsuario, BotonConImagen, BotonSencillo } from '../../../routeIndex';
import { BsBoxArrowInRight } from 'react-icons/bs';
import { useNavigate, useParams } from 'react-router-dom';

function AdministrarPerfil() {

    const navigate = useNavigate()

    const { rol, iduser } = useParams();

    return (
        <Template view='perfil'>

            <div className='btn_PerfilCommon'>

                <h1> Administrar perfil {rol} {iduser} </h1>

                <div className='botonCerrarSesion'>
                    <BotonConImagen
                        onClick={'Hola'}
                        backgroundColor='grisClaro'
                        size="grande"
                        Image={BsBoxArrowInRight}
                    >
                        Cerrar Sesión
                    </BotonConImagen>
                </div>

            </div>

            <div className='boxPerfilCommon'>
                <InformacionPersonalUsuario idUserParam={iduser} rolUserParam={rol} />
            </div>

            <div className='containerBtnEliminarCuenta'>
                <BotonSencillo
                    onClick={() => alert("Se debe preguntar para confirmar la eliminación")}
                    backgroundColor='negro'
                    size='grande'
                >
                    Eliminar cuenta
                </BotonSencillo>
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
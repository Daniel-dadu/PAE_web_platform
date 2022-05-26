import React, { useState } from 'react'
import './administrarPerfilAsesoradoDirectivos.css'
import { PopUpGeneral, Template, InformacionPersonalUsuario, BotonConImagen, BotonSencillo } from '../../../routeIndex';
import { BsBoxArrowInRight } from 'react-icons/bs';

function AdministrarPerfilAsesoradoDirectivos() {

    const [active, setActive] = useState(true);

    const togglePopUpGeneral = () => {
        setActive(!active)
    }

    window.togglePopUpGeneral = togglePopUpGeneral;

    return (

        <div>
            <PopUpGeneral tipoPopUpGeneral={false} nombreEliminar='Mario Alonso' state={active} funcion={togglePopUpGeneral}>
                </PopUpGeneral>
            <Template view='perfil'>

                

                <div className='btn_PerfilCommon'>

                    <h1> Administrar perfil </h1>

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
                    <InformacionPersonalUsuario> </InformacionPersonalUsuario>
                </div>

                <div className='containerBtnEliminarCuenta'>
                    <BotonSencillo
                        onClick={togglePopUpGeneral}
                        backgroundColor='negro'
                        size='grande'
                    >
                        Eliminar cuenta
                    </BotonSencillo>
                </div>

            </Template>

        </div>

    )

}

export default AdministrarPerfilAsesoradoDirectivos
import React from 'react';
import { Template, InformacionPersonalUsuario, BotonConImagen } from '../../../routeIndex';
import './perfilAsesorado.css';
import { BsBoxArrowInRight } from 'react-icons/bs'




function PerfilAsesorado() {
  return (
      <>
        <Template view={"perfil"} >
          <div className = 'btn_PerfilCommon'>

            <h1> Perfil </h1>

            <div className = 'botonCerrarSesion'>
                <BotonConImagen 
                    onClick = {'Hola'} 
                    backgroundColor = 'grisClaro'
                    size = "grande" 
                    Image = {BsBoxArrowInRight}
                >
                    Cerrar Sesión
                </BotonConImagen>
            </div>

          </div>
        
          <div className='contenedor-informacion-perfilAsesorado'>
            <InformacionPersonalUsuario />
          </div>
        </Template>
      </>
  )
}

export default PerfilAsesorado
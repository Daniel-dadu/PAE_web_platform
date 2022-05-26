import React, { useState } from 'react';
import { PopUpGeneral, Template, InformacionPersonalUsuario, BotonSencillo } from '../../../routeIndex';
import './administrarPerfilAsesorDirectivos.css';



const AdministrarPerfilAsesorDirectivos = () => {

  const [active, setActive] = useState(true);

  const togglePopUpGeneral = () => {
    setActive(!active)
  }

  window.togglePopUpGeneral = togglePopUpGeneral;


  return (
    <>

      <PopUpGeneral 
        tipoPopUpGeneral={false} 
        nombreEliminar='Mario Alonso' 
        state={active} 
        funcion={togglePopUpGeneral} 
      />

      <Template view='perfil'>

        <div className='btn_PerfilCommon'>
          <h1>Administrar Perfiles</h1>
        </div>

        <div className='boxPerfilCommon'>
          <InformacionPersonalUsuario> </InformacionPersonalUsuario>
        </div>

        <div className={ 'containerBtnEliminarCuentaAsesor' }>
          <BotonSencillo
            onClick={togglePopUpGeneral}
            backgroundColor='negro'
            size='grande'
          >
            Eliminar cuenta
          </BotonSencillo>

          <BotonSencillo
              onClick={togglePopUpGeneral}
              backgroundColor='verde'
              size='grande'
              >
              Descargar Estadisticas
          </BotonSencillo> 
          
        </div>
      </Template>

    </>
  )
}

export default AdministrarPerfilAsesorDirectivos
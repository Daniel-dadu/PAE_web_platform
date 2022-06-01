import React, { useState } from 'react';
import { Template, PupUpSolicitudAsesoria } from '../../../routeIndex';
import './danielFlores.css';

const DanielFlores = () => {
  const [active, setActive] = useState(false);

  const handleActive = () => {
    setActive(!active);
  }
  return (
    <>

        <PupUpSolicitudAsesoria  activo={active} accion={ handleActive } />
        
        <Template view="perfil">
          <button onClick={ handleActive }>PopUp solicitud asesoria</button>
        </Template>


    </>
  )
}

export default DanielFlores
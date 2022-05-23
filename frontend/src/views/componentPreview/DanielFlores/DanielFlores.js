import React, { useState } from 'react'
import { Template, ListaUnidadesDeFormacionAsesor, PopUpEncuesta } from '../../../routeIndex'
import './danielFlores.css';

const DanielFlores = () => {

  const [activoEncuesta, setActivoEncuesta] = useState(false);

const cerrarEncuesta = () => {
    setActivoEncuesta(!activoEncuesta);
    
}

  return (
    <>
        <PopUpEncuesta activo={activoEncuesta} ocultarPopUp={cerrarEncuesta} />

        <Template view="perfil">

          
          <div className='div-prueba-df'>
            <button onClick={ cerrarEncuesta }> Abrir PupUpEncuesta </button>
          </div> 



        </Template>


    </>
  )
}

export default DanielFlores
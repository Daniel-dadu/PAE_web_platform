import React, { useState } from 'react'
import PopUpGeneral from '../../../components/reusable/PopUpGeneral/PopUpGeneral'
import { Template, BarraProgreso, TarjetaMaestraMini } from '../../../routeIndex'


const DanielFlores = () => {

  const [state, setState] = useState(true);  

  const handleBtn = () => {
    setState(!state);
  }

  return (
    <>
        <Template view="perfil">
            <PopUpGeneral tipoPopUpGeneral= { false } state={ state } funcion={ handleBtn } />
            <button onClick={ handleBtn }> Prueba </button>
        </Template>
    </>
  )
}

export default DanielFlores
import React, { useState } from 'react'
import { Template, BarraProgreso, TarjetaMaestraMini, ListaDesplegable } from '../../../routeIndex'
import './danielFlores.css';

const DanielFlores = () => {

  

  return (
    <>
        <Template view="perfil">
          <div className='div-prueba-df'>

          </div>

          {/* <ListaDesplegable tipo={ 1 } semestre={1} /> */}
          <ListaDesplegable tipo={ 2 } fecha="7 de marzo del 2022" />

        </Template>
    </>
  )
}

export default DanielFlores
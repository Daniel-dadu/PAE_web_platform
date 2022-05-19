import React, { useState } from 'react'
import { Template, BarraProgreso, TarjetaMaestraMini, InformacionPersonalUsuario } from '../../../routeIndex'
import './danielFlores.css';

const DanielFlores = () => {

  return (
    <>
        <Template view="perfil">
          <div className='div-prueba-df'>
              <h1>Prueba de espacio, nada que ver</h1>
          </div>

          <InformacionPersonalUsuario />
        </Template>
    </>
  )
}

export default DanielFlores
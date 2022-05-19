import React, { useState } from 'react'
import { Template, BarraProgreso, TarjetaMaestraMini, TarjetaListaDesplegable } from '../../../routeIndex'
import './danielFlores.css';

const DanielFlores = () => {

  return (
    <>
        <Template view="perfil">
          <div className='div-prueba-df'>
              <h1>Prueba de espacio, nada que ver</h1>
          </div>

          <TarjetaListaDesplegable tipo={ 3 } claveUF="TC3005B" colorTipo3="verde_tipo3" horaAsesoria="11 AM" contenido=" Ezequiel Lozano Guerrero le dará asesoria a Daniel Maldonado Espitia " />
        </Template>
    </>
  )
}

export default DanielFlores
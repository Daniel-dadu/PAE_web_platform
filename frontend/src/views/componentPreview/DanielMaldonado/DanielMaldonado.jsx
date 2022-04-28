import React from 'react'
import { Template, BotonConImagen, CampoSeleccionarEnListaDesplegable, CampoTextoPequeno, CampoTextoGrande } from '../../../routeIndex'

import './DanielMaldonado.css'
import { IoMdCopy } from 'react-icons/io'

function DanielMaldonado() {
  let list = [
    'ITC (Ingenieria en Tecnologías Computacionales)',
    'IBT (Ingenieria en Biotecnología)',
    'IFI (Ingenieria Física Industrial)',
    'IMT (Ingenieria Mecatrónica)',
  ];

  return (
    <div>
      <Template user="asesorado" tema="claro" idioma="espanol" view="calendario">
        <BotonConImagen onClick = {() => {alert('Me diste click :)')}} backgroundColor = 'verde' size = 'reducido' Image={IoMdCopy}>
          Cerrar sesion
        </BotonConImagen>

        <CampoSeleccionarEnListaDesplegable options={list} size="big"/>

        <br />
        <br />
        
        <CampoTextoPequeno size="last"/>
        
        <br />
        <br />
        
        <CampoTextoGrande size="last"/>

        <h1>sdjahfsd</h1>
        <a href="/asdf">link</a>
        <ul>
          <li>Hola</li>
          <li>Hola</li>
          <li>Hola</li>
          <li>Hola</li>
          <li>Hola</li>
          <li>Hola</li>
        </ul>
        <h2>A continuación, mucho texto</h2>
      </Template>
    </div>
  )
}

export default DanielMaldonado
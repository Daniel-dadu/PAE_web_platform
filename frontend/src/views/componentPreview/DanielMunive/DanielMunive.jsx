import React, { useState } from 'react'
import { PopUpInformacionAsesoria }  from '../../../routeIndex'

import  Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal';

import EjemploJSON from './pruebasGrandes.json'

import './Munive.css'
function DanielMunive() {

  const [active, setActive] = useState(false);

  const toggle = () => {
    setActive(!active)
  }

  return (
    <div className='.fullPantalla'> 

      <button style={{
        position: 'absolute',
        top: '50%',
        padding: 10,
      }} onClick={toggle}>Open Modal</button>


      <Modal active={active} toggle={toggle}>
      <PopUpInformacionAsesoria  userTypePopUpAsesoria = "alumno" infoAsesoria = {EjemploJSON}></PopUpInformacionAsesoria> 
      </Modal>

    

    </div>

  )
}

export default DanielMunive
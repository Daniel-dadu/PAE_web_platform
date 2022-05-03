import React from 'react'
import { PopUpInformacionAsesoria }  from '../../../routeIndex'

import EjemploJSON from './pruebasGrandes.json'
function DanielMunive() {
  return (
    <div> 

    <PopUpInformacionAsesoria  userTypePopUpAsesoria = "alumno" infoAsesoria = {EjemploJSON}></PopUpInformacionAsesoria>

    </div>

  )
}

export default DanielMunive
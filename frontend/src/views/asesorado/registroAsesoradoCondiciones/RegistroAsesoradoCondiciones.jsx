import React from 'react'

import { TemplateRegistroUsuario } from '../../../routeIndex'

import "./RegistroAsesoradoCondiciones.css"

import Condiciones from './condiciones.json'

let progressBar = {
    "currentStep": 1,
    "steps": [
        {
            "name" : "Datos Generales",
            "state": true,
            "next": "enable",
            "path" : "/registroAsesoradoDatos"
          }, 
          {
            "name" : "Consideraciones Finales",
            "state": null,
            "next": "enable",
            "path" : "./registroAsesoradoCondiciones"
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "./registroAsesoradoResumen"
          }
    ]
  }

function RegistroAsesoradoCondiciones() {
  return (

    <TemplateRegistroUsuario 
    progressBarJSON = {progressBar}
     btnAtrasRoute="./registroAsesoradoDatos"
     btnSiguienteRoute="./registroAsesoradoResumen"> 
        
    <div className='bloq_condicionesAsesorado'>
       <h1 className='campo_RegistroAsesoradoCondiciones'> CAMPO 2: Consideraciones Finales </h1>

       <h1 className='condicionesAsesorado_texto'> Acepta los terminos y condiciones de uso </h1>
     
     </div>

   <div className='condicionesAsesorado'>

   <div className='condiciones_condicionesAsesorado'> <p className='texto_condiciones_condicionesAsesorado'> {Condiciones.Condiciones} </p> </div>
     
     <div> 
       <input type="checkbox" id="condiciones" name="condiciones" value="AceptoCondiciones"/>
       <label htmlFor="condiciones" style={{fontSize: "20px"}} > Acepto los terminos y condiciones</label>
     </div>



   </div>

   
   
    </TemplateRegistroUsuario>
  )
}

export default RegistroAsesoradoCondiciones
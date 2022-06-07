import React from 'react'

import { TemplateRegistroUsuario } from '../../../routeIndex'


import "./RegistroAsesorCondiciones.css"

import Condiciones from './condiciones.json'

let progressBar = {
  "currentStep": 3,
  "steps": [
      {
          "name" : "Datos Generales",
          "state": true,
          "next": "enable",
          "path" : "/registroAsesorDatos"
        }, 
        {
          "name" : "Horario",
          "state": true,
          "next": "enable",
          "path" : "Ruta"
        },
        {
          "name" : "Unidad de Formacion",
          "state": true,
          "next": "enable",
          "path" : "Ruta"
        },
        {
          "name" : "Consideraciones Finales",
          "state": null,
          "next": "enable",
          "path" : "./registroAsesorCondiciones"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "Ruta"
        }
  ]
}

function RegistroAsesorCondiciones() {
  return (
        
         <TemplateRegistroUsuario 
         progressBarJSON = {progressBar}
          btnAtrasRoute="./registroAsesorUF"
          btnSiguienteProps={{ view: 4, props: null }}
          isRegistroAsesor={true}> 
             
         <div className='bloq_condicionesAsesor'>
            <h1 className='campo_RegistroAsesorCondiciones'> CAMPO 4: Consideraciones Finales </h1>

            <h1 className='condicionesAsesor_texto'> Acepta los terminos y condiciones de uso </h1>
          
          </div>

        <div className='condicionesAsesor'>

        <div className='condiciones_condicionesAsesor'> <p className='texto_condiciones_condicionesAsesor'> {Condiciones.Condiciones} </p> </div>
          
          <div> 
            <input type="checkbox" id="condiciones" name="condiciones" value="AceptoCondiciones"/>
            <label for="condiciones" style={{fontSize: "20px"}} > Acepto los terminos y condiciones</label>
          </div>



        </div>

        
        
         </TemplateRegistroUsuario>

  )
}

export default RegistroAsesorCondiciones
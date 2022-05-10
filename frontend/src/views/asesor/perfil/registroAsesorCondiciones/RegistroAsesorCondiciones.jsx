import React from 'react'

import { TemplateRegistroUsuario, BarraProgreso } from '../../../../routeIndex'


import "./RegistroAsesorCondiciones.css"

function RegistroAsesorCondiciones(progressBarJSON) {
  return (
    <div>
        
         <TemplateRegistroUsuario> 
             
         <div >
            <h1 >Agendar asesorías</h1>
            <BarraProgreso progress={progressBarJSON}/>
        </div>
        
         </TemplateRegistroUsuario> 

        
    </div>
  )
}

export default RegistroAsesorCondiciones
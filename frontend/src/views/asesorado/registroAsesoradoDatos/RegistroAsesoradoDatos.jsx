import React from 'react'

import { TemplateRegistroUsuario, CampoTextoPequeno, CampoSeleccionarEnListaDesplegable, ImagenPerfilCambiar } from '../../../routeIndex'

import info from './info.json'

import "./RegistroAsesoradoDatos.css"

let progressBar = {
    "currentStep": 0,
    "steps": [
        {
            "name" : "Datos Generales",
            "state": null,
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

function RegistroAsesoradoDatos() {


  return (
    <TemplateRegistroUsuario 
    progressBarJSON = {progressBar}
     btnAtrasRoute="./landingPage"
     btnSiguienteRoute="./registroAsesoradoCondiciones"> 

        <div>
            <h1 className='campo_RegistroAsesoradoDatos'> CAMPO 1: Datos generales </h1>
            <h3 className='advertencia_asterisco'> * Los campos con asteríscos son obligatorios </h3>  
        </div>

        <div className='contener_DatosAsesoradoInputRegistro'> 

            <div className='contenedro_deInputsAsesoradoRegistro'> 
                <div className='texto_contenedor_deInputsAsesoradoRegistro'> Nombre (s) </div>
                <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
            </div>

            <div className='contenedro_deInputsAsesoradoRegistro'> 
                <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Paterno </div>
                <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
            </div>

            <div className='contenedro_deInputsAsesoradoRegistro'> 
                <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Materno </div>
                <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
            </div>

            <div className='contenedro_deInputsAsesoradoRegistro'> 
                <div className='texto_contenedor_deInputsAsesoradoRegistro'> Matrícula</div>
                <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
            </div>

            <div className='contenedro_deInputsAsesoradoRegistro'> 
                <div className='texto_contenedor_deInputsAsesoradoRegistro'> Carrera  </div>
                <CampoSeleccionarEnListaDesplegable size="medium" options={info.carrera} idList="semestre"/>
            </div>


            <div className='contenedro_deInputsAsesoradoRegistro'> 
                <div className='texto_contenedor_deInputsAsesoradoRegistro'> Número de teléfono (opcional)  </div>
                <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
            </div>

            <div> 
                <p className='texto_contenedor_deInputsAsesoradoRegistro' style={{width: 'fit-content', margin: 'auto'}}> Imagen de Perfil </p>
                
                <ImagenPerfilCambiar />
    
            </div>

        </div>
        
    </TemplateRegistroUsuario>
  )
}

export default RegistroAsesoradoDatos
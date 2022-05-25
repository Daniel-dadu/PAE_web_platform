import React from 'react'

import "./AdministrarUsuarios.css"

import  respuetasEncuestas  from  './imagesAdministra/respuestasEncuestas.png'
import  administrarAsesores  from  './imagesAdministra/administrarAsesores.png'
import  administrarAsesorados  from  './imagesAdministra/administrarAsesorados.png'

import { Template, BotonAdministrarInformacion } from '../../../routeIndex'

function AdministrarUsuarios() {
  return (
    <div>

        <Template view='administrar'>
        <h1 className='title_administrarUsuarios'>Administrar información</h1>
            <div className='contenedor_administrarUsuarios'>

        <div className='grupoBotones_administrarUsuarios'>

            <div className='botonesSuperiores_administrarUsuarios'> 

        <BotonAdministrarInformacion 
                onClick={() => {alert('Administrar asesores')}}  
                Imagen={administrarAsesores} 
                children='Administrar asesores'> 
            </BotonAdministrarInformacion>

            <BotonAdministrarInformacion 
                onClick={() => {alert('Administrar asesorados')}}  
                Imagen={administrarAsesorados} 
                children='Administrar asesorados'> 
            </BotonAdministrarInformacion>

            </div>

            <div className='botonesInferiores_administrarUsuarios'> 
            <BotonAdministrarInformacion 
                onClick={() => {alert('Respuestas de encuestas a asesores')}}  
                Imagen={respuetasEncuestas} 
                children='Respuestas de encuestas a asesores'> 
            </BotonAdministrarInformacion>


            <BotonAdministrarInformacion 
                onClick={() => {alert('Respuestas de encuestas a asesorados')}}  
                Imagen={respuetasEncuestas} 
                children='Respuestas de encuestas a asesorados'> 
            </BotonAdministrarInformacion>

            </div>


        </div>
        </div>

        </Template>
    </div>
  )
}

export default AdministrarUsuarios
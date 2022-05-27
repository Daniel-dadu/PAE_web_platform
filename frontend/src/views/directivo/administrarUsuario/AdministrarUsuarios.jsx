import React from 'react'

import "./AdministrarUsuarios.css"

import  respuetasEncuestas  from  './imagesAdministra/respuestasEncuestas.png'
import  administrarAsesores  from  './imagesAdministra/administrarAsesores.png'
import  administrarAsesorados  from  './imagesAdministra/administrarAsesorados.png'

import { Template, BotonAdministrarInformacion } from '../../../routeIndex'
import { useNavigate } from 'react-router-dom'

function AdministrarUsuarios() {

    const navigate = useNavigate()
  return (
    <div>

        <Template view='administrar'>
        <h1 className='title_administrarUsuarios'>Administrar información</h1>
            <div className='contenedor_administrarUsuarios'>

        <div className='grupoBotones_administrarUsuarios'>

            <div className='botonesSuperiores_administrarUsuarios'> 

        <BotonAdministrarInformacion 
                onClick={() => navigate('/informacionUsuarios')}  
                Imagen={administrarAsesores} 
                children='Administrar asesores'> 
            </BotonAdministrarInformacion>

            <BotonAdministrarInformacion 
                onClick={() => navigate('/informacionUsuarios')}  
                Imagen={administrarAsesorados} 
                children='Administrar asesorados'> 
            </BotonAdministrarInformacion>

            </div>

            <div className='botonesInferiores_administrarUsuarios'> 
            <BotonAdministrarInformacion 
                onClick={() => navigate('/respuestasEncuestas')}  
                Imagen={respuetasEncuestas} 
                children='Respuestas de encuestas a asesores'> 
            </BotonAdministrarInformacion>


            <BotonAdministrarInformacion 
                onClick={() => navigate('/respuestasEncuestas')}  
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
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
                onClick={() => navigate('/administrarAsesores')}  
                Imagen={administrarAsesores} 
                children='Administrar asesores'> 
            </BotonAdministrarInformacion>

            <BotonAdministrarInformacion 
                onClick={() => navigate('/administrarAsesorados')}  
                Imagen={administrarAsesorados} 
                children='Administrar asesorados'> 
            </BotonAdministrarInformacion>

            <BotonAdministrarInformacion 
                onClick={() => navigate('/administrarDirectivos')}  
                Imagen={administrarAsesorados} 
                children='Administrar directivos'> 
            </BotonAdministrarInformacion>

            </div>

            <div className='botonesInferiores_administrarUsuarios'> 
            <BotonAdministrarInformacion 
                onClick={() => navigate('/respuestasEncuestasAsesores')}  
                Imagen={respuetasEncuestas} 
                children='Respuestas de encuestas a asesores'> 
            </BotonAdministrarInformacion>


            <BotonAdministrarInformacion 
                onClick={() => navigate('/respuestasEncuestasAsesorados')}  
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
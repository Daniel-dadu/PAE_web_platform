import React, { useState, useEffect } from 'react'

import { useNavigate } from "react-router-dom"

import { TemplateRegistroUsuario } from '../../../routeIndex'

import "./RegistroAsesoradoCondiciones.css"

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
            "path" : "/registroAsesoradoCondiciones"
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesoradoCondiciones"
          }
    ]
  }

function RegistroAsesoradoCondiciones() {
  
  let navigate = useNavigate()

  // Verificamos que se cuente con todos campos obligatorios
  // Si no, se envía al usuario a la landing page
  useEffect(() => {
    if(!localStorage.registro1_nombre || 
    !localStorage.registro1_apellidoPaterno || 
    !localStorage.registro1_matricula || 
    !localStorage.registro1_carrera) {
      localStorage.clear()
      navigate('/landingPage')
      return
    }
  }, [navigate])

  const [userChecked, setUserChecked] = useState(false)

  const [condicionesApiState, setCondicionesApiState] = useState({
    loading: false, // Booleano que indica si está consultando (cargando) la info de la API
    apiData: null // Guarda la información que regresa la API
  })

  const [errorCondicionesApiCall, setErrorCondicionesApiCall] = useState(null)

  useEffect(() => {
    setCondicionesApiState({ loading: true })
    fetch('http://20.225.209.57:3090/registro/politica_vigente')
      .then(res => res.json()) // Se indica que la respuesta se regresará en un JSON
      .then(
        // En caso de que se obtenga la información de la API, se actualiza la info
        APIdata => setCondicionesApiState({ loading: false, apiData: APIdata }), 
        // En caso de que haya un error, se actualiza el error
        error => {
          setCondicionesApiState({ loading: false })
          setErrorCondicionesApiCall(error)
        }
      )
  }, [setCondicionesApiState, setErrorCondicionesApiCall])

  return (

    <TemplateRegistroUsuario 
      progressBarJSON = {progressBar}
      btnAtrasRoute="./registroAsesoradoDatos"
      btnSiguienteProps={ 
      {
        view: 2, 
        props: errorCondicionesApiCall ? null : { userChecked }
      } 
    }> 
        
    <div className='bloq_condicionesAsesorado'>
      <h1 className='campo_RegistroAsesoradoCondiciones'> CAMPO 2: Consideraciones Finales </h1>
    </div>

    {
      (errorCondicionesApiCall) ? 
        <div style={{color: 'red', width: 'fit-content', margin: 'auto'}}>
          <h2> Intente de nuevo más tarde </h2>
          <h3 style={{marginBottom: '5rem', marginLeft:'5rem'}}> Error: {errorCondicionesApiCall.message} </h3>
        </div> 

      : (condicionesApiState.loading) ? 
        <p style={{marginBottom: '5rem', width: 'fit-content', margin: 'auto'}}> Cargando... </p>

      :
        <div className='condicionesAsesorado'>
          <h2 className='condicionesAsesorado_texto'> {condicionesApiState.apiData ? condicionesApiState.apiData.titulo : 'Cargando...' } </h2>

          <div className='condiciones_condicionesAsesorado'> 
            <p className='texto_condiciones_condicionesAsesorado' align='justify'> 
              {condicionesApiState.apiData ? condicionesApiState.apiData.descripcion : 'Cargando...'} 
            </p> 
          </div>
          
          <div> 
            <input type="checkbox" id="condiciones" name="condiciones" value="AceptoCondiciones" onChange={() => setUserChecked(!userChecked)} />
            <label htmlFor="condiciones" style={{fontSize: "20px"}} > Acepto los terminos y condiciones</label>
          </div>

        </div>
    }

    </TemplateRegistroUsuario>
  )
}

export default RegistroAsesoradoCondiciones
import React, { useState, useEffect } from 'react'

import { TemplateRegistroUsuario } from '../../../routeIndex'


import "./RegistroAsesorCondiciones.css"


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
          "path" : "/registroAsesorHorario"
        },
        {
          "name" : "Unidad de Formacion",
          "state": true,
          "next": "enable",
          "path" : "/registroAsesorUF"
        },
        {
          "name" : "Consideraciones Finales",
          "state": null,
          "next": "enable",
          "path" : "/registroAsesorCondiciones"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "/registroAsesorCondiciones"
        }
  ]
}

function RegistroAsesorCondiciones() {
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
      btnAtrasRoute="./registroAsesorUF"
      btnSiguienteProps={{ view: 4, props: errorCondicionesApiCall ? null : { userChecked } }}
      isRegistroAsesor={true}
    > 
        
    <div className='bloq_condicionesAsesor'>
      <h1 className='campo_RegistroAsesorCondiciones'> CAMPO 4: Consideraciones Finales </h1>
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
        <div className='condicionesAsesor'>
          <h2 className='condicionesAsesor_texto'> {condicionesApiState.apiData ? condicionesApiState.apiData.titulo : 'Cargando...' } </h2>

          <div className='condiciones_condicionesAsesor'> 
            <p className='texto_condiciones_condicionesAsesor' align='justify'> 
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

export default RegistroAsesorCondiciones
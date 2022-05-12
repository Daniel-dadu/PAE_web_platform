import React, { useEffect, useState } from 'react'
import './AgendarAsesoriaUF.css'

import info from './info.json'

import { AgendarAsesoria, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'

let progressBar = {
  "currentStep": 0,
  "steps": [
      {
          "name" : "Selección",
          "state": null,
          "next": "done",
          "path" : "./AgendarAsesoriaUF"
        }, 
        {
          "name" : "Información",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        },
        {
          "name" : "Fecha",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        },
        {
          "name" : "Hora",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
      }
  ]
}

function AgendarAsesoriaUF() {

  // const [appData, setAppData] = useState(null)

  const [appState, setAppState] = useState({
    loading: false,
    apiData: null,
  })
  const [error, setError] = useState(null)

  useEffect(() => {
    setAppState({ loading: true })
    fetch('http://20.225.209.57:3094/asesoria/get_carreras')
      .then(res => res.json())
      .then(
        APIdata => {
          const carrerasApi = APIdata.map(carrera => carrera.idCarrera + " - " + carrera.nombreCarrera)
          setAppState({ loading: false, apiData: carrerasApi })
          // setAppState({ loading: false, apiData: APIdata })
        }, 
        error => {
          setAppState({ loading: false })
          setError(error);
        }
      )
  }, [setAppState])


  if(error)
    return <div>Error: {error.message}</div>;
  else if(setAppState.loading)
    return (
      <AgendarAsesoria 
      showAtrasBtn={false} 
      btnAtrasRoute="" 
      btnSiguienteRoute="./AgendarAsesoriaDuda" 
      showTarjetaMaestraMini={true} 
      sizeTarjetaMaestraMini="normal" 
      progressBarJSON={progressBar}
    >
      Cargando...
    </AgendarAsesoria>
    )

  else
  return (
    <AgendarAsesoria 
      showAtrasBtn={false} 
      btnAtrasRoute="" 
      btnSiguienteRoute="./AgendarAsesoriaDuda" 
      showTarjetaMaestraMini={true} 
      sizeTarjetaMaestraMini="normal" 
      progressBarJSON={progressBar}
    >
      <div className='container_out_aauf'>
        <div className='container_in_aauf'>
          <h3>Carrera</h3>
          {
            appState.apiData === null || appState.apiData === undefined ?
            <CampoSeleccionarEnListaDesplegable size="medium" options={["Cargando"]} idList="semestre"/>
            : 
            <CampoSeleccionarEnListaDesplegable size="medium" options={appState.apiData} idList="semestre"/>
          }
          <h3>Semestre</h3>
          <CampoSeleccionarEnListaDesplegable size="small" options={info.semestre} idList="carrera"/>
          <h3>Unidad de formación</h3>
          <CampoSeleccionarEnListaDesplegable size="medium" options={info.unidadFormacion} idList="unidadFormacion"/>
        </div>
      </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaUF
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

  // Hook usado para conocer el estado de la petición a la API para consultar las carreras
  const [carreraApiState, setCarreraApiState] = useState({
    loading: false, // Booleano que indica si está consultando (cargando) la info de la API
    apiData: null // Guarda la información que regresa la API
  })
  // Hook usado para indicar el error de la petición a la API para consultar las carreras, en caso de que ocurra
  const [errorCarreraApiCall, setErrorCarreraApiCall] = useState(null)

  // Hook para hacer la llamada a la API haciendo uso de la función fetch de JS
  useEffect(() => {
    setCarreraApiState({ loading: true })
    fetch('http://20.225.209.57:3094/asesoria/get_carreras')
      .then(res => res.json()) // Se indica que la respuesta se regresará en un JSON
      .then(
        // En caso de que se obtenga la información de la API, se actualiza el carreraApiState
        APIdata => {
          const carrerasApi = APIdata.map(carrera => carrera.idCarrera + " - " + carrera.nombreCarrera)
          setCarreraApiState({ loading: false, apiData: carrerasApi })
        }, 
        // En caso de que haya un error, se actualiza el error
        error => {
          setCarreraApiState({ loading: false })
          setErrorCarreraApiCall(error);
        }
      )
  }, [setCarreraApiState])


  // Hook para guardar la carrera seleccionada
  const [carreraSeleccionada, setCarreraSeleccionada] = useState(null)
  // Función que recibe la carrera seleccionada en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a carreraSeleccionada
  const handleCarrera = carreraValue => {
    console.log(carreraValue.value)
    setCarreraSeleccionada(carreraValue.value)
  }
  
  // Hook para guardar el semestre seleccionado
  const [semestreSeleccionado, setSemestreSeleccionado] = useState(null)
  // Función que recibe el semestre seleccionado en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a semestreSeleccionado
  const handleSemestre = semestreValue => {
    console.log(semestreValue.value)
    setSemestreSeleccionado(semestreValue.value)
  }


  // Hook usado para conocer el estado de la petición a la API para consultar las UFs
  const [ufApiState, setUfApiState] = useState({
    loading: false, // Booleano que indica si está consultando (cargando) la info de la API
    apiData: null // Guarda la información que regresa la API
  })
  // Hook usado para indicar el error de la petición a la API para consultar las UFs, en caso de que ocurra
  const [errorUfApiCall, setErrorUfApiCall] = useState(null)

  ////////////////////////////////////////////////////////////////////////////
  /////////// TypeError: Failed to execute 'fetch' on 'Window': Request with GET/HEAD method cannot have body.

  const obj = {
    "carrera": "ITC",
    "semestre": 2
  }

  let fetchData = {
    method: 'GET',
    body: JSON.stringify(obj),
  }

  // Hook para hacer la llamada a la API haciendo uso de la función fetch de JS
  useEffect(() => {
    setUfApiState({ loading: true })
    fetch('http://20.225.209.57:3094/asesoria/get_uf/', fetchData)
      .then(res => res.json()) // Se indica que la respuesta se regresará en un JSON
      .then(
        // En caso de que se obtenga la información de la API, se actualiza el ufApiState
        APIdata => {
          console.log(APIdata[0]);
          // const ufsApi = APIdata.map(uf => uf.claveUF + " - " + uf.nombreUF)
          const ufsApi = ["1", "2"]
          setUfApiState({ loading: false, apiData: ufsApi })
        }, 
        // En caso de que haya un error, se actualiza el error
        error => {
          setUfApiState({ loading: false })
          setErrorUfApiCall(error);
        }
      )
  }, [setUfApiState])

  ////////////////////////////////////////////////////////////////////////////

  return (
    <AgendarAsesoria 
      showAtrasBtn={false} 
      btnAtrasRoute="" 
      btnSiguienteRoute="./AgendarAsesoriaDuda" 
      showTarjetaMaestraMini={true} 
      sizeTarjetaMaestraMini="normal" 
      progressBarJSON={progressBar}
    >
      {
        (errorCarreraApiCall) ? // Si ocurre un error en la llamada a la API, se entra en este bloque
        <div>
          <h2>
            Intente de nuevo más tarde
          </h2>
          <h3>
            Error: {errorCarreraApiCall.message}
          </h3>
        </div> 

        : (carreraApiState.loading) ? // Si todavía no se obtienen los datos de la API, se entra en este bloque
        <div>
          Cargando...
        </div>

        : // Si todo sale bien con la llamada a la API, se entra en este bloque
        <div className='container_out_aauf'>
          <div className='container_in_aauf'>

            <h3 id="CarreraTitleInput">Carrera</h3>
            {
              carreraApiState.apiData === null || carreraApiState.apiData === undefined ?
              <CampoSeleccionarEnListaDesplegable size="medium" options={["Cargando..."]}/>
              : 
              <CampoSeleccionarEnListaDesplegable size="medium" options={carreraApiState.apiData} parentCallback={handleCarrera}/>
            }

            <h3>Semestre</h3>
            <CampoSeleccionarEnListaDesplegable size="small" options={[1,2,3,4,5,6,7,8,9]} parentCallback={handleSemestre}/>
            
            <h3>Unidad de formación</h3>
            {
              (errorUfApiCall || ufApiState.loading) ?
              <CampoSeleccionarEnListaDesplegable size="medium" options={["Cargando..."]}/>
              :
              <CampoSeleccionarEnListaDesplegable size="medium" options={ufApiState.apiData}/>
            }

            <button onClick={() => console.log(carreraSeleccionada)}>Carrerita</button>
            <button onClick={() => console.log(semestreSeleccionado)}>Semestree</button>
            <button onClick={() => console.log(ufApiState)}>UF_Api</button>
          </div>
        </div>

      }

    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaUF
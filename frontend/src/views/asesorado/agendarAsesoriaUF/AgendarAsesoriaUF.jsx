import React, { useEffect, useState } from 'react'
import './AgendarAsesoriaUF.css'
import { FaSearch } from 'react-icons/fa'

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

  // ****************** Hooks y código usado para la consulta de las carreras a la API ****************** //

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

  // ************************************************************************************************ //


  // ****************** Hooks y código usado para la consulta de las UFs a la API ****************** //

  // Hook para guardar las opciones de las unidades de formación
  const [opcionesUF, setOpcionesUF] = useState([])
  // Opción por defecto que se debe mostrar en caso de que no se haya seleccionado la carrera y/o el semestre
  const defaultUFoption = ["* Una vez selecciones la carrera y el semestre, presiona el botón de la lupa para buscar la unidad de formación correspondiente"]

  // Hook para guardar la UF seleccionada
  const [ufSeleccionada, setUfSeleccionada] = useState(null)
  // Función que recibe la UF seleccionada en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a carreraSeleccionada
  const handleUF = ufValue => setUfSeleccionada(ufValue.value[0] === '*' ? null : ufValue.value)

  // Hook para guardar la carrera seleccionada
  const [carreraSeleccionada, setCarreraSeleccionada] = useState(null)
  // Función que recibe la carrera seleccionada en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a carreraSeleccionada
  const handleCarrera = carreraValue => {
    setOpcionesUF(defaultUFoption) // En caso de que se haga un cambio en la carrera, se establece la opcion por default en las opcionesUF
    setUfSeleccionada(null)
    setCarreraSeleccionada(carreraValue.value)
  }
  
  // Hook para guardar el semestre seleccionado
  const [semestreSeleccionado, setSemestreSeleccionado] = useState(null)
  // Función que recibe el semestre seleccionado en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a semestreSeleccionado
  const handleSemestre = semestreValue => {
    setOpcionesUF(defaultUFoption) // En caso de que se haga un cambio en la carrera, se establece la opcion por default en las opcionesUF
    setUfSeleccionada(null)
    setSemestreSeleccionado(semestreValue.value)
  }

  // Hook usado para conocer el estado de la petición a la API para consultar las UFs
  const [ufApiState, setUfApiState] = useState({
    loading: true, // Booleano que indica si está consultando (cargando) la info de la API
    apiData: null // Guarda la información que regresa la API
  })
  // Hook usado para indicar el error de la petición a la API para consultar las UFs, en caso de que ocurra
  const [errorUfApiCall, setErrorUfApiCall] = useState(null)

  // Función que hace la llamada a la api para consultar las UFs (solo se ejecuta cuando se le llama en el botón de la lupa)
  const ufApiCall = () => {
    setUfApiState({ loading: true })
    // A la request le agregamos los query params necesarios para esta consulta
    fetch('http://20.225.209.57:3094/asesoria/get_uf/?' + new URLSearchParams({
      carrera: carreraSeleccionada.slice(0, carreraSeleccionada.indexOf(" ")), // Cortamos el string para usar únicamente el ID de la carrera
      semestre: semestreSeleccionado
    }))
      .then(res => res.json()) // Se indica que la respuesta se regresará en un JSON
      .then(
        APIdata => {
          // Si se hizo una consulta con una combinación de semestre y carrera inválida, la API regresa un error
          let optionsList = APIdata.hasOwnProperty("ERROR") ?
          ["* ERROR: " + APIdata["ERROR"]] : // Se muestra el mensaje de error de la API
          APIdata.map(uf => uf.claveUF + " - " + uf.nombreUF) // Si no hay error, se junta el id con el nombre de la UF

          // Se actualizan los hooks
          setUfApiState({ loading: false, apiData: optionsList })
          setOpcionesUF(optionsList)
        }, 
        // En caso de que haya un error, se actualiza el error
        error => {
          setUfApiState({ loading: false })
          setErrorUfApiCall(error)
          setOpcionesUF(defaultUFoption)
        }
      )
  }

  // ************************************************************************************************ //

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
            
            <div className='ufTitleLupa_container'>
              <h3 id="CarreraTitleInput3">Unidad de formación</h3>
              <button onClick={() => ufApiCall()} className="lupaIcon">
                <FaSearch size={17}/>
              </button>
            </div>
            {
              (errorUfApiCall || ufApiState.loading) ? 
              <CampoSeleccionarEnListaDesplegable size="medium" options={defaultUFoption} parentCallback={handleUF} />
              :
              <CampoSeleccionarEnListaDesplegable size="medium" options={opcionesUF} parentCallback={handleUF} />
            }

            <button onClick={() => alert("Opciones seleccionadas:\n" + carreraSeleccionada + "\n" + semestreSeleccionado + " \n" + ufSeleccionada)}>
              data selected
            </button>

          </div>
        </div>

      }

    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaUF
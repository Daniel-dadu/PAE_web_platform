import React, { useEffect, useState } from 'react'
import { useParams, useNavigate } from "react-router-dom"
import './AgendarAsesoriaUF.css'

import { AgendarAsesoria, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'

let progressBar = {
  "currentStep": 0,
  "steps": [
      {
          "name" : "Selección",
          "state": null,
          "next": "done",
          "path" : "/agendarAsesoriaUF/ok"
        }, 
        {
          "name" : "Información",
          "state": null,
          "next": "enable",
          "path" : "/agendarAsesoriaUF/ok"
        },
        {
          "name" : "Fecha",
          "state": null,
          "next": "enable",
          "path" : "/agendarAsesoriaUF/ok"
        },
        {
          "name" : "Hora",
          "state": null,
          "next": "enable",
          "path" : "/agendarAsesoriaUF/ok"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "/agendarAsesoriaUF/ok"
      }
  ]
}

// Función que recibe un string con el id carrera y el nombre de la carrera
// Ejemplo de entrada: "ITC - Ingeniería en Tecnologías Computacionales"
// Regresa el string con las siglas o ID de la carrera
// Ejemplo de return: "ITC"
const getIDstring = str => str.slice(0, str.indexOf(" "))


function AgendarAsesoriaUF() {

  // Hook para navegar a otra ruta
  const navigate = useNavigate();

  // Variable para usar el parámetro que se recibe en la ruto
  const { statusasesoriaurl } = useParams();

  // Variable para ir contando las veces que se muestra el mensaje de error (para que no se muestre más de una vez)
  let countErrorMessage = 0

  // Hook para verificar si se recibió un error en la ruta
  useEffect(() => {
    if(statusasesoriaurl === "error" && countErrorMessage === 0) {
      alert("Error, intente hacer la reservación nuevamente")
      navigate('/agendarAsesoriaUF/ok') // Se redirige al usuario a la ruta con el ok
      window.location.reload(false) // Se recarga la página para limpiar los campos seleccionados
      countErrorMessage++
    } 
  }, [statusasesoriaurl, countErrorMessage, navigate])

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
    fetch('http://20.225.209.57:3091/general/get_carreras')
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
  const defaultUFoption = []

  // Hook con las propiedades que se le envían al botón "Siguiente"
  const [infoBtnSiguiente, setInfoBtnSiguiente] = useState(null)

  // Hook para guardar la carrera seleccionada
  const [carreraSeleccionada, setCarreraSeleccionada] = useState(localStorage.asesoria_carrera ? localStorage.asesoria_carrera : null)
  // Hook para guardar el semestre seleccionado
  const [semestreSeleccionado, setSemestreSeleccionado] = useState(localStorage.asesoria_semestre ? localStorage.asesoria_semestre : null)

  // Función que recibe la carrera seleccionada en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a carreraSeleccionada
  const handleCarrera = carreraValue => {
    setOpcionesUF(defaultUFoption) // En caso de que se haga un cambio en la carrera, se establece la opcion por default en las opcionesUF
    setInfoBtnSiguiente({ 
      carrera: carreraValue.value,
      semestre: semestreSeleccionado,
      uf: null 
    }) 
    setCarreraSeleccionada(carreraValue.value)

    if(semestreSeleccionado) ufApiCall(carreraValue.value, semestreSeleccionado)
  }

  // Función que recibe el semestre seleccionado en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a semestreSeleccionado
  const handleSemestre = semestreValue => {
    setOpcionesUF(defaultUFoption) // En caso de que se haga un cambio en la carrera, se establece la opcion por default en las opcionesUF
    setInfoBtnSiguiente({ 
      carrera: carreraSeleccionada,
      semestre: semestreValue.value,
      uf: null 
    })
    setSemestreSeleccionado(semestreValue.value)

    if(carreraSeleccionada) ufApiCall(carreraSeleccionada, semestreValue.value)
  }

  // Hook usado para conocer el estado de la petición a la API para consultar las UFs
  const [ufApiState, setUfApiState] = useState({
    loading: true, // Booleano que indica si está consultando (cargando) la info de la API
    apiData: null // Guarda la información que regresa la API
  })
  // Hook usado para indicar el error de la petición a la API para consultar las UFs, en caso de que ocurra
  const [errorUfApiCall, setErrorUfApiCall] = useState(null)

  // Función que recibe la UF seleccionada en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a carreraSeleccionada
  const handleUF = ufValue => {
    setInfoBtnSiguiente({
      carrera: carreraSeleccionada,
      semestre: semestreSeleccionado,
      uf: ufValue.value[0] === '*' ? null : getIDstring(ufValue.value) // Cortamos el string para usar únicamente el ID de la carrera
    })
  }

  // Función que hace la llamada a la api para consultar las UFs (solo se ejecuta cuando se le llama en el botón de la lupa)
  const ufApiCall = (carreraParam, semestreParam) => {
    
    // const carreraAPI = carreraSeleccionada ? carreraSeleccionada : carreraParam
    // const semestreAPI = semestreSeleccionado ? semestreSeleccionado : semestreParam

    setUfApiState({ loading: true })
    // A la request le agregamos los query params necesarios para esta consulta
    fetch('http://20.225.209.57:3094/asesoria/get_uf/?' + new URLSearchParams({
      carrera: getIDstring(carreraParam), // Cortamos el string para usar únicamente el ID de la carrera
      semestre: semestreParam
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

  const [userChecked, setUserChecked] = useState(false)

  const clickOptativasOnly = () => {
    setUserChecked(!userChecked)
    if(userChecked) {
      const carreraOpt = 'OPTG - Optativa General'
      const semestreOpt = 1
      setCarreraSeleccionada(carreraOpt)
      setSemestreSeleccionado(semestreOpt)
      ufApiCall(carreraOpt, semestreOpt)
    }
  }


  return (
    <AgendarAsesoria 
      showAtrasBtn={false} 
      btnAtrasRoute="" 
      btnSiguienteProps={{view: 1, props: infoBtnSiguiente}}
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
          
          <h2 className='title_instructions_agendarAsesoria'>Selecciona la materia o unidad de formación en la que tienes duda</h2>
          <h4 className='subtitle_instructions_agendarAsesoria'>Primero indica a qué carrera y semestre corresponde dicha Unidad de formación</h4>

          <div className='container_in_aauf'>

            <div className='container_optativasOnly_checkbox'> 
              <input type="checkbox" id="optativas" name="optativas" value="SoloOptativas" onChange={() => clickOptativasOnly()} />
              <label htmlFor="optativas" > Solo mostrar optativas </label>
            </div>

            <div className={ !userChecked ? 'container-boxBlocked carrera' : '' } ></div>
            <h3 id="CarreraTitleInput">Carrera</h3>
            {
              carreraApiState.apiData === null || carreraApiState.apiData === undefined ?
              <CampoSeleccionarEnListaDesplegable 
                size="medium" 
                options={["Cargando..."]} 
                defaultValue={carreraSeleccionada} 
              />
              : 
              <CampoSeleccionarEnListaDesplegable 
                size="medium" 
                options={carreraApiState.apiData}
                parentCallback={handleCarrera}
                defaultValue={carreraSeleccionada}
              />
            }

            <div className={ !userChecked ? 'container-boxBlocked semestre' : '' } ></div>
            <h3>Semestre</h3>

              <CampoSeleccionarEnListaDesplegable 
                size="small" 
                options={[1,2,3,4,5,6,7,8,9]} 
                parentCallback={handleSemestre}
                defaultValue={semestreSeleccionado}
              />
            
            <h3 id="CarreraTitleInput3">Unidad de formación</h3>
            {
              (errorUfApiCall || ufApiState.loading) ? 
              <CampoSeleccionarEnListaDesplegable 
                size="medium" 
                options={defaultUFoption} 
                parentCallback={handleUF} 
                defaultValue={localStorage.asesoria_uf ? localStorage.asesoria_uf : ''} 
              />
              :
              <CampoSeleccionarEnListaDesplegable 
                size="medium" 
                options={opcionesUF} 
                parentCallback={handleUF} 
                defaultValue={localStorage.asesoria_uf ? localStorage.asesoria_uf : ''}
              />
            }

          </div>
        </div>

      }

    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaUF
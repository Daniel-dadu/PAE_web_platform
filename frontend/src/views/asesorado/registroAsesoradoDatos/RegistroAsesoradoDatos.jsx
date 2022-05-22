import React, { useState, useEffect } from 'react'

import { TemplateRegistroUsuario, CampoTextoPequeno, CampoSeleccionarEnListaDesplegable, ImagenPerfilCambiar } from '../../../routeIndex'

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

    // Limpiamos el local storage
    // localStorage.clear()

    const [nombre, setNombre] = useState('')
    const handleTextNombre = textInserted => setNombre(textInserted)

    const [apellidoParterno, setApellidoParterno] = useState('')
    const handleTextApellidoParterno = textInserted => setApellidoParterno(textInserted)

    const [apellidoMarterno, setApellidoMarterno] = useState('')
    const handleTextApellidoMarterno = textInserted => setApellidoMarterno(textInserted)

    const [matricula, setMatricula] = useState('')
    const handleTextMatricula = textInserted => setMatricula(textInserted)

    const [carrera, setCarrera] = useState('')
    const handleCarrera = carreraValue => setCarrera(carreraValue.value)
    
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

    const [telefono, setTelefono] = useState('')
    const handleTextTelefono = textInserted => setTelefono(textInserted)

    const [imageUploaded, setImageUploaded] = useState(null)
    const onHandleUploadImage = image => setImageUploaded(image)

    return (
        <TemplateRegistroUsuario 
        progressBarJSON = {progressBar}
        btnAtrasRoute="./landingPage"
        btnSiguienteProps={ 
            {
                view: 1, 
                props: errorCarreraApiCall ? null : { nombre, apellidoParterno, apellidoMarterno, matricula, carrera, telefono, imageUploaded }
            } 
        } > 

            <div>
                <h1 className='campo_RegistroAsesoradoDatos'> CAMPO 1: Datos generales </h1>
                <h3 className='advertencia_asterisco'> * Los campos con asteríscos son obligatorios </h3>  
            </div>

        {
        (errorCarreraApiCall) ? // Si ocurre un error en la llamada a la API, se entra en este bloque
            <div style={{color: 'red', width: 'fit-content', margin: 'auto'}}>
                <h2> Intente de nuevo más tarde </h2>
                <h3 style={{marginBottom: '5rem', marginLeft:'5rem'}}> Error: {errorCarreraApiCall.message} </h3>
            </div> 

        : (carreraApiState.loading) ? // Si todavía no se obtienen los datos de la API, se entra en este bloque
            <p style={{marginBottom: '5rem', width: 'fit-content', margin: 'auto'}}>
                Cargando...
            </p>

        : // Si todo sale bien con la llamada a la API, se entra en este bloque

            <div className='contener_DatosAsesoradoInputRegistro'> 

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Nombre(s) * </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextNombre} />
                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Paterno * </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextApellidoParterno} />
                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Materno </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextApellidoMarterno} />
                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Matrícula *</div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextMatricula} />
                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Carrera * </div>
                    {
                        carreraApiState.apiData === null || carreraApiState.apiData === undefined ?
                        <CampoSeleccionarEnListaDesplegable size="large" options={["Cargando..."]}/>
                        : 
                        <CampoSeleccionarEnListaDesplegable size="large" options={carreraApiState.apiData} parentCallback={handleCarrera}/>
                    }
                </div>


                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Número de teléfono </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextTelefono}/>
                </div>

                <div className='contenedor_imagenPerfil'> 
                    <p className='texto_contenedor_deInputsAsesoradoRegistro title_imagenPerfil'> Imagen de Perfil </p>
                    <ImagenPerfilCambiar onUploadImage={onHandleUploadImage} />
                </div>

            </div>
        }

            
        </TemplateRegistroUsuario>
    )
}

export default RegistroAsesoradoDatos
import React, { useState, useEffect } from 'react'

import { TemplateRegistroUsuario, CampoTextoPequeno, CampoSeleccionarEnListaDesplegable, ImagenPerfilCambiar } from '../../../routeIndex'

import "./RegistroAsesorDatos.css"

let progressBar = {
    "currentStep": 0,
    "steps": [
        {
            "name" : "Datos Generales",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesorDatos"
          }, 
          {
            "name" : "Horario",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesorDatos"
          },
          {
            "name" : "Unidad de Formacion",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesorDatos"
          },
          {
            "name" : "Consideraciones Finales",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesorDatos"
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesorDatos"
          }
    ]
  }

function RegistroAsesorDatos() {

    const matriculaUser = localStorage.registro1_matricula
    const contrasenaUser = localStorage.registro1_contrasena
    const nombreUser = localStorage.registro1_nombre
    const apellidoPatUser = localStorage.registro1_apellidoPaterno
    const apellidoMatUser = localStorage.registro1_apellidoMaterno
    const carreraUser = localStorage.registro1_carrera
    const carrera2User = localStorage.registro1_carrera2
    const semestreUser = localStorage.registro1_semestre
    const telefonoUser = localStorage.registro1_telefono
    const imagenUser = localStorage.registro1_imagenPerfil

    const [matricula, setMatricula] = useState(matriculaUser ? matriculaUser : '')
    const handleTextMatricula = textInserted => setMatricula(textInserted)
    
    const [contrasena, setContrasena] = useState(contrasenaUser ? contrasenaUser : '')
    const handleTextContrasena = textInserted => setContrasena(textInserted)
    const [contrasenaConfirm, setContrasenaConfirm] = useState(contrasenaUser ? contrasenaUser : '')
    const handleTextContrasenaConfirm = textInserted => setContrasenaConfirm(textInserted)

    const [nombre, setNombre] = useState(nombreUser ? nombreUser : '')
    const handleTextNombre = textInserted => setNombre(textInserted)

    const [apellidoParterno, setApellidoParterno] = useState(apellidoPatUser ? apellidoPatUser : '')
    const handleTextApellidoParterno = textInserted => setApellidoParterno(textInserted)

    const [apellidoMarterno, setApellidoMarterno] = useState(apellidoMatUser ? apellidoMatUser : '')
    const handleTextApellidoMarterno = textInserted => setApellidoMarterno(textInserted)

    const [carrera, setCarrera] = useState(carreraUser ? carreraUser : '')
    const handleCarrera = carreraValue => setCarrera(carreraValue.value)
    const [carrera2, setCarrera2] = useState(carrera2User ? carrera2User : '')
    const handleCarrera2 = carreraValue => setCarrera2(carreraValue.value)
    
    const [semestre, setSemestre] = useState(semestreUser ? semestreUser : '')
    const handleSemestre = semestreValue => setSemestre(semestreValue.value)
    
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
    }, [setCarreraApiState, setErrorCarreraApiCall])

    // ************************************************************************************************ //

    const [telefono, setTelefono] = useState(telefonoUser ? telefonoUser : '')
    const handleTextTelefono = textInserted => setTelefono(textInserted)

    const [imageUploaded, setImageUploaded] = useState(imagenUser ? imagenUser : null)
    const onHandleUploadImage = image => setImageUploaded(image)

    return (
        <TemplateRegistroUsuario 
        progressBarJSON = {progressBar}
        btnAtrasRoute="./landingPage"
        btnSiguienteProps={{
            view: 1, 
            props: errorCarreraApiCall ? null : 
                { nombre, apellidoParterno, apellidoMarterno, matricula, carrera, carrera2, semestre, telefono, imageUploaded, contrasena, contrasenaConfirm }
        }}
        isRegistroAsesor={true} > 

            <div>
                <h1 className='campo_RegistroAsesorDatos'> CAMPO 1: Datos generales </h1>
                <h3 className='advertencia_asterisco'> * Los campos con asteríscos son obligatorios </h3>  
            </div>

        {
        (errorCarreraApiCall) ? // Si ocurre un error en la llamada a la API, se entra en este bloque
            <div style={{color: 'red', width: 'fit-content', margin: 'auto'}}>
                <h2> Intente de nuevo más tarde </h2>
                <h3 style={{marginBottom: '5rem', marginLeft:'5rem'}}> Error: {errorCarreraApiCall.message} </h3>
            </div> 

        : (carreraApiState.loading) ? // Si todavía no se obtienen los datos de la API, se entra en este bloque
            <p style={{marginBottom: '5rem', width: 'fit-content', margin: 'auto'}}> Cargando... </p>

        : // Si todo sale bien con la llamada a la API, se entra en este bloque

            <div className='contener_DatosAsesorInputRegistro'> 

                <div className='contenedro_deInputsAsesorRegistro_credenciales'>
                    <p align='center' style={{fontStyle: 'italic'}}>Credenciales para el acceso a la plataforma</p>

                    <div className='contenedro_deInputsAsesorRegistro'> 
                        <div className='texto_contenedor_deInputsAsesorRegistro'> 
                            Matrícula *
                            { matricula.length < 9 && <span className='input_incorrecto'>La matrícula debe tener 9 caracteres</span> }
                        </div>
                        <CampoTextoPequeno maxNumCaracteres="9" size="big" onInsertText={handleTextMatricula} previousText={matriculaUser}/>
                    </div>
                    <div className='contenedro_deInputsAsesorRegistro'> 
                        <div className='texto_contenedor_deInputsAsesorRegistro'> 
                            Contraseña *
                            { contrasena.length < 8 && <span className='input_incorrecto'>La contraseña debe tener al menos 8 caracteres</span> } 
                        </div>
                        <CampoTextoPequeno size="big" onInsertText={handleTextContrasena} previousText={contrasenaUser} isPassword={true}/>
                    </div>
                    <div className='contenedro_deInputsAsesorRegistro'> 
                        <div className='texto_contenedor_deInputsAsesorRegistro'> 
                            Confirmar contraseña * 
                            { contrasena !== contrasenaConfirm && <span className='input_incorrecto'>Las contraseñas no coinciden</span> } 
                        </div>
                        <CampoTextoPequeno size="big" onInsertText={handleTextContrasenaConfirm} previousText={contrasenaUser} isPassword={true} />
                    </div>
                </div>

                <div className='contenedro_deInputsAsesorRegistro'> 
                    <div className='texto_contenedor_deInputsAsesorRegistro'> Nombre(s) * </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextNombre} previousText={nombreUser} />
                </div>

                <div className='contenedro_deInputsAsesorRegistro'> 
                    <div className='texto_contenedor_deInputsAsesorRegistro'> Apellido Paterno * </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextApellidoParterno} previousText={apellidoPatUser}/>
                </div>

                <div className='contenedro_deInputsAsesorRegistro'> 
                    <div className='texto_contenedor_deInputsAsesorRegistro'> Apellido Materno </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextApellidoMarterno} previousText={apellidoMatUser}/>
                </div>

                <div className='contenedro_deInputsAsesorRegistro'> 
                    <div className='texto_contenedor_deInputsAsesorRegistro'> Carrera * </div>
                    {
                        carreraApiState.apiData === null || carreraApiState.apiData === undefined ?
                        <CampoSeleccionarEnListaDesplegable size="large" options={["Cargando..."]} defaultValue={carrera} />
                        : 
                        <CampoSeleccionarEnListaDesplegable size="large" options={carreraApiState.apiData} parentCallback={handleCarrera} defaultValue={carrera}/>
                    }
                </div>
                <div className='contenedro_deInputsAsesorRegistro'> 
                    <div className='texto_contenedor_deInputsAsesorRegistro'> 2da Carrera </div>
                    {
                        carreraApiState.apiData === null || carreraApiState.apiData === undefined ?
                        <CampoSeleccionarEnListaDesplegable size="large" options={["Cargando..."]} defaultValue={carrera2} />
                        : 
                        <CampoSeleccionarEnListaDesplegable size="large" options={carreraApiState.apiData} parentCallback={handleCarrera2} defaultValue={carrera2}/>
                    }
                </div>

                <div className='contenedro_deInputsAsesorRegistro'> 
                    <div className='texto_contenedor_deInputsAsesorRegistro'> Semestre * </div>
                    <CampoSeleccionarEnListaDesplegable size="small" options={[1,2,3,4,5,6,7,8,9]} parentCallback={handleSemestre} defaultValue={semestre}/>
                </div>


                <div className='contenedro_deInputsAsesorRegistro'> 
                    <div className='texto_contenedor_deInputsAsesorRegistro'> Número de teléfono </div>
                    <CampoTextoPequeno maxNumCaracteres="10" size="big" onInsertText={handleTextTelefono} previousText={telefonoUser}/>
                </div>

                <div className='contenedor_imagenPerfil'> 
                    <p className='texto_contenedor_deInputsAsesorRegistro title_imagenPerfil'> Imagen de Perfil </p>
                    <ImagenPerfilCambiar onUploadImage={onHandleUploadImage} previousImage={ imagenUser }/>
                </div>

            </div>
        }

            
        </TemplateRegistroUsuario>
    )
}

export default RegistroAsesorDatos
import React, {useState, useEffect} from 'react'
import { TemplateRegistroUsuario, ListaUnidadesDeFormacionAsesor, CambioMesPeriodo, CalendarioDisponibilidad } from '../../../routeIndex'
import "./RegistroAsesorResumen.css"
import { useNavigate } from 'react-router-dom'

import noUserImg from '../../../assets/noUserImg.png'


let progressBar = {
  "currentStep": 4,
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
          "path" : "Ruta"
        },
        {
          "name" : "Unidad de Formacion",
          "state": true,
          "next": "enable",
          "path" : "Ruta"
        },
        {
          "name" : "Consideraciones Finales",
          "state": true,
          "next": "enable",
          "path" : "./registroAsesorCondiciones"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "./registroAsesorResumen"
        }
  ]
}

function RegistroAsesorResumen() {

    let navigate = useNavigate()

    const nombreUser = localStorage.registro1_nombre
    const apellidoPatUser = localStorage.registro1_apellidoPaterno
    const matriculaUser = localStorage.registro1_matricula
    const carreraUser = localStorage.registro1_carrera
    const carrera2User = localStorage.registro1_carrera2
    const semestreUser = localStorage.registro1_semestre
    const telefonoUser = localStorage.registro1_telefono
    const imagenUser = localStorage.registro1_imagenPerfil
    const UFsUser = localStorage.registro1_UFs

    const localStoragePeriodos = [
        localStorage.registro1_horarioPeriodo1, 
        localStorage.registro1_horarioPeriodo2, 
        localStorage.registro1_horarioPeriodo3
    ]

    useEffect(() => {
        [
            localStorage.registro1_horarioPeriodo1, 
            localStorage.registro1_horarioPeriodo2, 
            localStorage.registro1_horarioPeriodo3
        ]
        .forEach(periodo => {
            if(!periodo){
                alert("Error: No se cuenta con todos los datos. Intente nuevamente.")
                navigate('/RegistroAsesorDatos')
            } 
        })

        if(!nombreUser || !apellidoPatUser || !matriculaUser || !carreraUser || !semestreUser || !UFsUser) {
            alert("Error: No se cuenta con todos los datos. Intente nuevamente.")
            navigate('/RegistroAsesorDatos')
            return
        }

    }, [navigate, nombreUser, apellidoPatUser, matriculaUser, carreraUser, semestreUser, UFsUser])

    // Variable para conocer la fecha de hoy y actualizar el año
    const currentYear = (new Date()).getFullYear()

    // Variable de tipo objeto para actuazlizar los valores del periodo y año
    const [periodo, setPeriodo] = useState({ num: "Periodo 1", anio: currentYear })

    const horarioPeriodos = [ 
        JSON.parse(localStoragePeriodos[0]), 
        JSON.parse(localStoragePeriodos[1]), 
        JSON.parse(localStoragePeriodos[2])
    ]

    const [currentHorarioPeriodo, setCurrentHorarioPeriodo] = useState(horarioPeriodos[0])
  
    // Función para convertir el string del nombre del periodo a su número
    const periodoStringToNum = periodoString => parseInt(periodoString[periodoString.length-1]) - 1

    // Función que maneja se ejecuta cuando se da click a una flecha del componente CambioMesPeriodo
    const handleArrowClick = arrow => {
        const newPeriodo = periodo.num === "Periodo 1" ? (arrow === "back" ? "Periodo 1" : "Periodo 2") :
        periodo.num === "Periodo 2" ? (arrow === "back" ? "Periodo 1" : "Periodo 3") :
        (arrow === "back" ? "Periodo 2" : "Periodo 3")

        setPeriodo ({ num: newPeriodo, anio: currentYear })
        setCurrentHorarioPeriodo(horarioPeriodos[periodoStringToNum(newPeriodo)])
    }

    return (
        
        <TemplateRegistroUsuario 
            progressBarJSON = {progressBar}
            btnAtrasRoute = "./registroAsesorCondiciones"
            btnSiguienteProps={{ view: 5, props: "ignore" }}
            isRegistroAsesor={true}
            ultimoTexto='Confirmar'
        >

            <h1> Resumen de información </h1>
                    
            <div className='contenedor-InfPerUsuario-asesor'>

                <div className='contenedor-InfPerUsuario-izq' >
                    <div className='contenedor-img-perfil-InfPerUsuario'>
                        <img src={ imagenUser ? imagenUser : noUserImg } 
                            alt="imgProfile" 
                            className='imagen-InfPerUsuario'
                            style={{objectFit: 'cover'}}
                        />
                    </div>
                </div>

                <div className='contenedor-InfPerUsuario-der' >
                    <p className='etiqueta-nombre-InfPerUsuario' >
                        { nombreUser + " " + apellidoPatUser }
                    </p>
                    
                    <p className='etiqueta-matricula-InfPerUsuario' >
                        { matriculaUser }
                    </p>

                    <p className={ 'etiqueta-carrera-InfPerUsuario' }  >
                        <span style={{fontWeight: '600'}}>Carrera(s): </span> 
                        { carrera2User ? carreraUser + ", " + carrera2User : carreraUser }
                    </p>
                    
                    <p className={ 'etiqueta-carrera-InfPerUsuario' }  >
                        <span style={{fontWeight: '600'}}>Semestre: </span> 
                        { semestreUser }
                    </p>
                    
                    <p className={ 'etiqueta-telefono-InfPerUsuario' }  >
                        <span style={{fontWeight: '600'}}>Teléfono: </span> 
                        { telefonoUser ? telefonoUser : 'No se ingresó' }
                    </p>

                </div>

            </div>

            <div className = 'containerListaUFResumen'>
                <ListaUnidadesDeFormacionAsesor data = {JSON.parse(UFsUser)} />
            </div>

            <div className = 'containerCambioMesPeriodoResumen'>
                <CambioMesPeriodo dataSupInf={{textoSuperior: periodo.num, textoInferior: periodo.anio}} onClickArrow={handleArrowClick}/>  
            </div>

            <div className = 'containerCalendarioDisponibilidadResumen'>
                <CalendarioDisponibilidad previousHorario={currentHorarioPeriodo} blocked={true} />
            </div>

        </TemplateRegistroUsuario>

  )
}

export default RegistroAsesorResumen
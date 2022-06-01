import React, {useState, useEffect} from 'react'
import { TemplateRegistroUsuario, InformacionPersonalUsuario, ListaUnidadesDeFormacionAsesor, CambioMesPeriodo, CalendarioDisponibilidad } from '../../../routeIndex'
import "./RegistroAsesorResumen.css"
import { useNavigate } from 'react-router-dom'

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

const listaUF = [
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:1
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:1
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:2
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:2
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        }
    }
  
]

function RegistroAsesorResumen() {

    let navigate = useNavigate()

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
    }, [navigate])

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
            btnSiguienteProps={{ view: 5, props: null }}
            isRegistroAsesor={true}
        >

            <h1> Resumen de información </h1>

            <div className = 'containerPerfilAsesoradoResumen'>
                <InformacionPersonalUsuario>
                </InformacionPersonalUsuario>
            </div>

            <div className = 'containerListaUFResumen'>
                <ListaUnidadesDeFormacionAsesor data = {listaUF} />
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
import React, { useState } from 'react'
import { TemplateRegistroUsuario, CambioMesPeriodo, CalendarioDisponibilidad } from '../../../routeIndex'

import "./registroAsesorHorario.css"



let progressBar = {
  "currentStep": 1,
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
          "state": null,
          "next": "enable",
          "path" : "Ruta"
        },
        {
          "name" : "Consideraciones Finales",
          "state": null,
          "next": "enable",
          "path" : "./registroAsesorCondiciones"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "Ruta"
        }
  ]
}

function RegistroAsesorHorario() {


  // Variable para conocer la fecha de hoy y actualizar el año
  const currentYear = (new Date()).getFullYear()

  // Variable de tipo objeto para actuazlizar los valores del mes y año
  const [periodo, setPeriodo] = useState(
    {
      num: "Periodo 1",
      anio: currentYear
    }
  )

  const [horarioPeriodos, setHorarioPeriodos] = useState(
    [
      {
        lunes: [8,9,10],
        martes: [],
        miercoles: [],
        jueves: [],
        viernes: [],
        total: 0
      },
      {
        lunes: [],
        martes: [],
        miercoles: [],
        jueves: [],
        viernes: [],
        total: 0
      },
      {
        lunes: [],
        martes: [],
        miercoles: [],
        jueves: [],
        viernes: [],
        total: 0
      }
    ]
  )

  const [currentHorarioPeriodo, setCurrentHorarioPeriodo] = useState(horarioPeriodos[0])

  // Función que maneja se ejecuta cuando se da click a una flecha del componente CambioMesPeriodo
  const handleArrowClick = arrow => {
    const newPeriodo = periodo.num === "Periodo 1" ? (arrow === "back" ? "Periodo 1" : "Periodo 2") :
      periodo.num === "Periodo 2" ? (arrow === "back" ? "Periodo 1" : "Periodo 3") :
      (arrow === "back" ? "Periodo 2" : "Periodo 3")
    setPeriodo (
      {
        num: newPeriodo
        ,
        anio: currentYear
      }
    )
    const numberPeriodo = parseInt(newPeriodo[newPeriodo.length-1]) - 1
    setCurrentHorarioPeriodo(horarioPeriodos[numberPeriodo])
  }

  const getCurrentPeriodoNum = () => periodo.num === "Periodo 1" ? 0 : periodo.num === "Periodo 2" ? 1 : 2

  const onChangeHorario = horarioUpdated => {
    let newHorarios = horarioPeriodos
    newHorarios[getCurrentPeriodoNum()] = horarioUpdated

    setHorarioPeriodos(newHorarios)
  }



  return (
        
    <TemplateRegistroUsuario 
      progressBarJSON = {progressBar}
      btnAtrasRoute="./registroAsesorDatos"
      btnSiguienteProps={{ view: 2, props: null }}
      isRegistroAsesor={true}
    > 
      {/* encabezado del contenedor, donde va el titulo */}
      <div className='bloq_condicionesAsesor'>
        <h1 className='campo_RegistroAsesorCondiciones'> CAMPO 2: Elije tu disponibilidad </h1>
      </div>

      {/* contenido de la tarjeta y en donde se almacena el componente de CambioMesPeriodo y el componente de CalendarioDisponibilidad */}
      <div className = 'contenedor-cambio-periodo'>
        <CambioMesPeriodo dataSupInf={{textoSuperior: periodo.num, textoInferior: periodo.anio}} onClickArrow={handleArrowClick}/>
      </div>

      <div className = 'contenedor-calendarioDisponibilidad'>
        <CalendarioDisponibilidad parentCallback={onChangeHorario} previousHorario={currentHorarioPeriodo} />
      </div>
    
    </TemplateRegistroUsuario>

  )
}

export default RegistroAsesorHorario
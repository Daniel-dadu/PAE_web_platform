import React, { useState } from 'react'
import { TemplateRegistroUsuario, CambioMesPeriodo, CalendarioDisponibilidad } from '../../../routeIndex'
import dateFunctions from '../../../assets/reusableFunctions/dateFunctions.js'

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
  const [today, setToday] = useState(new Date())

  // Variable de tipo objeto para actuazlizar los valores del mes y año
  const [mesAnio, setmesAnio] = useState(
    {
      mes: dateFunctions.getMonthEspanol(today.getMonth()),
      anio: today.getFullYear()
    }
  )

    // Función que maneja se ejecuta cuando se da click a una flecha del componente CambioMesPeriodo
    // Recibe como parámetro el tipo de botón al que se le dió click y cambia el valor de 'mesAnio' y 'today'
    const handleArrowClick = arrow => {
      let currentMonth = mesAnio.mes

      if(currentMonth === 'Diciembre' && arrow === 'next') {
        setmesAnio(
          {
            mes: 'Enero',
            anio: today.getFullYear()+1
          }
        )
        setToday(new Date(today.getFullYear()+1, today.getMonth(), today.getDate()))

      } else if (currentMonth === 'Enero' && arrow === 'back') {
        setmesAnio(
          {
            mes: 'Diciembre',
            anio: today.getFullYear()-1
          }
        )
        setToday(new Date(today.getFullYear()-1, today.getMonth(), today.getDate()))

      } else {
        setmesAnio (
          {
            mes: dateFunctions.getMonthEspanol(
                arrow === 'next' ? dateFunctions.monthsEnNumero[currentMonth]+1 :
                dateFunctions.monthsEnNumero[currentMonth]-1
            ),
            anio: today.getFullYear()
          }
        )
      }
    }

  const [horarioPeriodo1, setHorarioPeriodo1] = useState(
    {
      lunes: [],
      martes: [],
      miercoles: [],
      jueves: [],
      viernes: [],
      total: 0
    }
  )
  
  const onChangeHorario = idHorario => {
    let newHorario = horarioPeriodo1

    const horaInt = idHorario.length < 4 ? parseInt(idHorario[2]) : parseInt(idHorario.substring(2,4))

    const updateNewHorario = (dia) => {
      const indexHora = newHorario[dia].indexOf(horaInt)

      if (indexHora === -1) {
        newHorario[dia].push(horaInt)
        newHorario.total++
      } else {
        newHorario[dia].splice(indexHora, 1)
        newHorario.total--
      }
    }

    // Si se selecciona una horario del lunes
    if(idHorario[0] === '0') updateNewHorario('lunes')
    
    // Si se selecciona una horario del martes
    else if(idHorario[0] === '1') updateNewHorario('martes')
    
    // Si se selecciona una horario del martes
    else if(idHorario[0] === '2') updateNewHorario('miercoles')
    
    // Si se selecciona una horario del martes
    else if(idHorario[0] === '3') updateNewHorario('jueves')
    
    // Si se selecciona una horario del martes
    else if(idHorario[0] === '4') updateNewHorario('viernes')

    setHorarioPeriodo1(newHorario)
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
        <CambioMesPeriodo dataSupInf={{textoSuperior: mesAnio.mes, textoInferior: mesAnio.anio}} onClickArrow={handleArrowClick}/>
      </div>

      <div className = 'contenedor-calendarioDisponibilidad'>
        <CalendarioDisponibilidad parentCallback={onChangeHorario} />
      </div>

      <button onClick={() => console.log(horarioPeriodo1)} >show horario</button>
    
    </TemplateRegistroUsuario>

  )
}

export default RegistroAsesorHorario
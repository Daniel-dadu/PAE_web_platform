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
          "state": true,
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
        setmesAnio(
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


  return (
        
        <TemplateRegistroUsuario 
         progressBarJSON = {progressBar}
          btnAtrasRoute="./calendario"
          btnSiguienteRoute="./calendario"
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
                <CalendarioDisponibilidad/>
            </div>

        
        
         </TemplateRegistroUsuario>

  )
}

export default RegistroAsesorHorario
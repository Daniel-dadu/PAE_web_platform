import React, { useState } from 'react'

import { Template, CambioMesPeriodo, ComponenteCalendario, PopUpInformacionAsesoria } from '../../../routeIndex'

import CalendarioJSON from './PruebaCommonCalendario.json'
import './CalendarioStyle.css'
import  Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal';

import dateFunctions from '../../../assets/reusableFunctions/dateFunctions.js'

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

function Calendario() {

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

  const [active, setActive] = useState(false);
  
  const toggle = () => {
    setActive(!active)
  }
  
  window.toggle = toggle;

  return (
    <>

    <Template view="calendario">
      <div className='container_titleCalendar'>
          <h1 className='title_calendario'>Próximas asesorías</h1>
          <div className='mesAno_style'>
            <CambioMesPeriodo dataSupInf={{textoSuperior: mesAnio.mes, textoInferior: mesAnio.anio}} onClickArrow={handleArrowClick} />
          </div>   
      </div>

      <Modal active={active} toggle={toggle}>
        <PopUpInformacionAsesoria  userTypePopUpAsesoria = "alumno" infoAsesoria = {CalendarioJSON} estado={toggle} /> 
      </Modal>


      <div className='calendarioStyle'> 
        <ComponenteCalendario
          userTypeCalendario = 'alumno'
          diasCalendario = {CalendarioJSON}
          sizeCalendario = 'grande'
          mes = {mesAnio.mes}
          anio = {mesAnio.anio}
        />
      </div>
    </Template>

  </>
  )
}

export default Calendario
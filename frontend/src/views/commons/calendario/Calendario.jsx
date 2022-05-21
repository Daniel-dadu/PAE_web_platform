import React, { useState } from 'react'

import { Template, CambioMesPeriodo, ComponenteCalendario, PopUpInformacionAsesoria } from '../../../routeIndex'

import CalendarioJSON from './PruebaCommonCalendario.json'
import './CalendarioStyle.css'
import  Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal';

import dateFunctions from '../../../assets/reusableFunctions/dateFunctions.js'

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

function Calendario() {

  const [today, setToday] = useState(new Date())

  const [mesAnio, setmesAnio] = useState(
    {
      mes: dateFunctions.getMonthEspanol(today.getMonth()),
      anio: today.getFullYear()
    }
  )

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
        />
      </div>
    </Template>

  </>
  )
}

export default Calendario
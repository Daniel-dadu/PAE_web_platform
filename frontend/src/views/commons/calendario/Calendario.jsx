import React from 'react'

import { Template, CambioMesPeriodo, ComponenteCalendario } from '../../../routeIndex'

import CalendarioJSON from './PruebaCommonCalendario.json'
import './CalendarioStyle.css'

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado


//Importante es Necesario revisar como se va a manejar el componente de PeriodoMesAño para manejar el calendario con este, y que se actualize el mes y el año el el componente y en el calendario
function Calendario() {
  return (
    <Template view="calendario">


        <div className='container_titleCalendar'>
            <h1 className='title_calendario'>Próximas asesorías</h1>

            <div className='mesAno_style'>  <CambioMesPeriodo dataSupInf={  [ 
          {id: 1,
          Sup: 'Abril',
          Inf: '2022'},
          
          {id: 2,
          Sup: 'Mayo',
          Inf: '2022'},
          
          {id: 3,
          Sup: 'Junio',
          Inf: '2022'}   ]  } > </CambioMesPeriodo>

        </div>   
        </div>


        <div className='calendarioStyle'> 
        <ComponenteCalendario
          userTypeCalendario = 'alumno' 
          diasCalendario = {CalendarioJSON} 
          sizeCalendario = 'grande' 
          />
        </div>


        </Template>
  )
}

export default Calendario
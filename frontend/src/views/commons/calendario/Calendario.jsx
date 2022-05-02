import React from 'react'

import { Template, CambioMesPeriodo, ComponenteCalendario } from '../../../routeIndex'

import CalendarioJSON from '../../../components/reusable/Calendario/PruebaCalendario.json'
import './CalendarioStyle.css'

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado


//Importante es Necesario revisar como se va a manejar el componente de PeriodoMesAño para manejar el calendario con este, y que se actualize el mes y el año el el componente y en el calendario
function Calendario() {
  return (
    <Template user="asesorado" tema="claro" idioma="espanol" view="agendarAsesoria">
        <div className='.container_titleCalendar '>
            <h1 className='title_calendario'>Próximas asesorías</h1>
        </div>

        <div className='mesAno_style'>

        <CambioMesPeriodo dataSupInf={  [ 
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

        <div className='calendarioStyle'> 
        <ComponenteCalendario
      userTypeCalendario = 'alumno' // Se usa para definir el tipo de usuario que ve el calendario
        // alumno
        // directivo
      diasCalendario = {CalendarioJSON} // JSON con los días (y cada día con sus asesorías) de la semana
        // NOTA: en el archivo JSON debe existir un campo "numeroDia", "isActive", "asesorias" y "onClickDirectivo",
        // este último debe almacenar la función para abrir el menú de todas las asesorías para un día en específico (SOLO APLICA CUANDO EL USUARIO ES DIRECTIVO, NO ALUMNO)
        // Para comprender mejor esto se debe ver el archivo 'PruebaCalendario.json' encontrado en la carpeta de este componente
      sizeCalendario = 'grande' // Tamaño del componente
        // normal
        // grande
        // reducido
        >
    </ComponenteCalendario>
        </div>





        </Template>
  )
}

export default Calendario
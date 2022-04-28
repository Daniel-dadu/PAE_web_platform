import React from 'react'
import './AgendarAsesoria.css'

import { Template, BarraProgreso } from '../../../routeIndex'

/*

*/

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

function AgendarAsesoria({children}) {
  return (
    <Template user="asesorado" tema="claro" idioma="espanol" view="agendarAsesoria">
        <h1>Agendar asesorías</h1>
        {/* <BarraProgreso/> */}
    </Template>
  )
}

export default AgendarAsesoria
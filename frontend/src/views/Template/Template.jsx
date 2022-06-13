import React from 'react'
import { BarraLateral, TarjetaMaestra } from '../../routeIndex'
import './Template.css'

// Descripción de las propiedades
/*
view: Solo se recibe un string que indique el tipo de pantalla en el que se encuentra el usuario
Tipos de view:
"perfil"
"calendario"
"notificaciones"
"agendarAsesoria"
"administrar"

Ejemplo de uso:
<Template view="agendarAsesoria">
  <h1>Hola</h1>
</Template>
*/

function Template({ view, children }) {
  return (
    <div className="container_templatee">
        
        <BarraLateral viewProp={view} />
        <TarjetaMaestra>
            {children}
        </TarjetaMaestra>
    </div>
  )
}

export default Template
import React from 'react'
import { BarraLateral, TarjetaMaestra } from '../../routeIndex'
import './Template.css'

function Template({ user, tema, idioma, view, children }) {
  return (
    <div className="container">
        <BarraLateral userProp={user} temaProp={tema} idiomaProp={idioma} viewProp={view} />
        <TarjetaMaestra>
            {children}
        </TarjetaMaestra>
    </div>
  )
}

export default Template
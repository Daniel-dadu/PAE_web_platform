import React from 'react'
import {Link} from 'react-router-dom'

function TemporalHome() {
  return (
    <div>
      <h1>Pestañas disponibles:</h1>
      <Link to='/landingPage'>Landing Page</Link>
      <Link to='/calendario'>Calendario</Link>
    </div>
  )
}

export default TemporalHome
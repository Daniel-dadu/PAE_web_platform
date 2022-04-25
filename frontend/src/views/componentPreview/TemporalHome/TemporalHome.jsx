import React from 'react'
import {Link} from 'react-router-dom'
import './TemporalHome.css'

function TemporalHome() {
  return (
    <div>
      <h1>Pestañas disponibles</h1>
      <Link to='/landingPage' className='link_tmp'>Landing Page</Link>
      <Link to='/calendario' className='link_tmp'>Calendario</Link>
      <Link to='/perfilAsesor' className='link_tmp'>Perfil Asesor</Link>
      <Link to='/perfilAsesorado' className='link_tmp'>Perfil Asesorado</Link>
      <Link to='/perfilDirectivo' className='link_tmp'>Perfil Directivo</Link>
      <Link to='/editarPerfil' className='link_tmp'>Editar Perfil</Link>
    </div>
  )
}

export default TemporalHome
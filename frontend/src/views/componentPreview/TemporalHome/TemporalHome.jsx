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
      
      <h2>Pestañas de pruebas</h2>
      <Link to='/danielFlores' className='link_tmp'>danielFlores</Link>
      <Link to='/danielMaldonado' className='link_tmp'>danielMaldonado</Link>
      <Link to='/danielMunive' className='link_tmp'>danielMunive</Link>
      <Link to='/ezequiel' className='link_tmp'>ezequiel</Link>
      <Link to='/fernando' className='link_tmp'>fernando</Link>

    </div>
  )
}

export default TemporalHome
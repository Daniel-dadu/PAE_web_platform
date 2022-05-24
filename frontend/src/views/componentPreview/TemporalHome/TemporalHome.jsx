import React from 'react'
import {Link} from 'react-router-dom'
import './TemporalHome.css'

function TemporalHome() {
  return (
    <div>
      <h1>Pestañas disponibles</h1>
      <Link to='/landingPage' className='link_tmp'>Landing Page</Link>
      <Link to='/calendario' className='link_tmp'>Calendario</Link>
      <Link to='/agendarAsesoriaUF/ok' className='link_tmp'>AgendarAsesoriaUF</Link>
      <Link to='/agendarAsesoriaDuda' className='link_tmp'>AgendarAsesoriaDuda</Link>
      <Link to='/agendarAsesoriaCalendario' className='link_tmp'>AgendarAsesoriaCalendario</Link>
      <Link to='/agendarAsesoriaHora' className='link_tmp'>AgendarAsesoriaHora</Link>
      <Link to='/agendarAsesoriaResumen' className='link_tmp'>AgendarAsesoriaResumen</Link>
      <Link to='/notificaciones' className='link_tmp'>Notificaciones</Link>

      <h1> Pestañas Asesorado </h1>
      <Link to='/registroAsesoradoDatos' className='link_tmp'>RegistroAsesoradoDatos</Link>
      <Link to='/registroAsesoradoCondiciones' className='link_tmp'>RegistroAsesorCondiciones</Link>
      <Link to='/registroAsesoradoResumen' className='link_tmp'>RegistroAsesorResumen</Link>

      <h1> Pestañas Asesor </h1> 
      <Link to='/registroAsesorDatos' className='link_tmp'>RegistroAsesorDatos</Link>
      <Link to='/registroAsesorCondiciones' className='link_tmp'>RegistroAsesorCondiciones</Link>
      <Link to='/registroAsesorResumen' className='link_tmp'>RegistroAsesorResumen</Link>
      
      <h2>Directivos</h2>
      <Link to='/administrarUsuarios' className='link_tmp'>AdministrarUsuarios</Link>
      <Link to='/informacionUsuarios' className='link_tmp'>InformacionUsuarios</Link>
      <Link to='/administrarPerfilAsesorados' className='link_tmp'> AdministrarPerfilAsesorados</Link>


      <h2>Próximamente</h2>
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
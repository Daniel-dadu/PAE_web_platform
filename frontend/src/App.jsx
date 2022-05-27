import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { RegistroAsesorUF, RespuestasEncuestas, AsesoriasExistentesDiaDirectivos, RegistroAsesorResumen, RegistroAsesorHorario, AdministrarPerfilAsesoradoDirectivos, AdministrarUsuariosDirectivos, RegistroAsesoradoDatos, RegistroAsesorDatos, PanelNotificaciones, RegistroAsesoradoCondiciones, RegistroAsesoradoResumen, RegistroAsesorCondiciones, AdministrarUsuarios, TemporalHome, LandingPage, Calendario, PerfilAsesor, PerfilAsesorado, PerfilDirectivo, EditarPerfil, AgendarAsesoriaUF, AgendarAsesoriaDuda, AgendarAsesoriaCalendario, AgendarAsesoriaHora, AgendarAsesoriaResumen, DanielFlores, DanielMaldonado, DanielMunive, Ezequiel, Fernando, EnviarNotificacionDirectivos } from './routeIndex'

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path='/' element={<TemporalHome />} />
        <Route path='/landingPage' element={<LandingPage />} />
        <Route path='/calendario' element={<Calendario/>} />
        <Route path='/perfilAsesor' element={<PerfilAsesor/>} />
        <Route path='/perfilAsesorado' element={<PerfilAsesorado/>} />
        <Route path='/perfilDirectivo' element={<PerfilDirectivo/>} />
        <Route path='/editarPerfil' element={<EditarPerfil/>} />
        <Route path='/notificaciones' element={<PanelNotificaciones/>} />

        {/* Views de Agendar Asesoría (asesorado) */}
        <Route path='/agendarAsesoriaUF/:statusasesoriaurl' element={<AgendarAsesoriaUF/>} />
        <Route path='/agendarAsesoriaDuda/' element={<AgendarAsesoriaDuda/>} />
        <Route path='/agendarAsesoriaCalendario' element={<AgendarAsesoriaCalendario/>} />
        <Route path='/agendarAsesoriaHora/:anio/:mes/:dia' element={<AgendarAsesoriaHora/>} />
        <Route path='/agendarAsesoriaResumen' element={<AgendarAsesoriaResumen/>} />

        <Route path='/danielFlores' element={<DanielFlores/>} />
        <Route path='/danielMaldonado' element={<DanielMaldonado/>} />
        <Route path='/danielMunive' element={<DanielMunive/>} />
        <Route path='/ezequiel' element={<Ezequiel/>} />
        <Route path='/fernando' element={<Fernando/>} />

        {/* Views de Registro de Asesorado */}
        <Route path='/registroAsesoradoCondiciones' element={<RegistroAsesoradoCondiciones/>} />
        <Route path='/registroAsesoradoDatos' element={<RegistroAsesoradoDatos/>} />
        <Route path='/registroAsesoradoResumen' element={<RegistroAsesoradoResumen/>} />

        {/* Views de Asesor  */}
        <Route path='/registroAsesorCondiciones' element={<RegistroAsesorCondiciones/>} />
        <Route path='/registroAsesorDatos' element={<RegistroAsesorDatos/>} />
        <Route path='/registroAsesorResumen' element={<RegistroAsesorResumen/>} />
        <Route path='/registroAsesorHorario' element={ <RegistroAsesorHorario/> }/>
        <Route path='/registroAsesorUF' element={ <RegistroAsesorUF/> }/>


          {/* Views de Directivos */}
        <Route path='/administrar' element={<AdministrarUsuarios/>} />
        <Route path='/informacionUsuarios' element={<AdministrarUsuariosDirectivos/>} />
        <Route path='/administrarPerfilAsesorados' element={<AdministrarPerfilAsesoradoDirectivos/>} />
        <Route path='/asesoriasExistentesDiaDirectivos' element={<AsesoriasExistentesDiaDirectivos/>} />
        <Route path='/respuestasEncuestas' element={<RespuestasEncuestas/>} />
        <Route path='/EnviarNotificacionDirectivos' element={<EnviarNotificacionDirectivos/>} />


        {/* Esta última ruta es a donde se redirige al usuario cuando se busca una ruta inexistente */}
        <Route path='*' element={<TemporalHome />} />
      </Routes>
    </Router>
  );
}

export default App;
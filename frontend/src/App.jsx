import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { RegistroAsesorCondiciones, TemporalHome, LandingPage, Calendario, PerfilAsesor, PerfilAsesorado, PerfilDirectivo, EditarPerfil, AgendarAsesoriaUF, AgendarAsesoriaDuda, AgendarAsesoriaCalendario, AgendarAsesoriaHora, AgendarAsesoriaResumen, DanielFlores, DanielMaldonado, DanielMunive, Ezequiel, Fernando } from './routeIndex'

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

        {/* Views de Agendar Asesoría (asesorado) */}
        <Route path='/agendarAsesoriaUF' element={<AgendarAsesoriaUF/>} />
        <Route path='/agendarAsesoriaDuda' element={<AgendarAsesoriaDuda/>} />
        <Route path='/agendarAsesoriaCalendario' element={<AgendarAsesoriaCalendario/>} />
        <Route path='/agendarAsesoriaHora' element={<AgendarAsesoriaHora/>} />
        <Route path='/agendarAsesoriaResumen' element={<AgendarAsesoriaResumen/>} />

        <Route path='/danielFlores' element={<DanielFlores/>} />
        <Route path='/danielMaldonado' element={<DanielMaldonado/>} />
        <Route path='/danielMunive' element={<DanielMunive/>} />
        <Route path='/ezequiel' element={<Ezequiel/>} />
        <Route path='/fernando' element={<Fernando/>} />

        {/* Views de Asesor (asesorado) */}
        <Route path='/registroAsesorCondiciones' element={<RegistroAsesorCondiciones/>} />

        {/* Esta última ruta es a donde se redirige al usuario cuando se busca una ruta inexistente */}
        <Route path='*' element={<TemporalHome />} />
      </Routes>
    </Router>
  );
}

export default App;

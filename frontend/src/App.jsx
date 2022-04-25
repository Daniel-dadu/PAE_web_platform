import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import TemporalHome from './views/componentPreview/TemporalHome/TemporalHome';
import LandingPage from './views/LandingPage/LandingPage';
import Calendario from './views/commons/Calendario/Calendario';
import  PerfilAsesor  from './views/asesor/perfil/PerfilAsesor';
import  PerfilAsesorado  from './views/asesorado/perfil/PerfilAsesorado';
import PerfilDirectivo from './views/directivo/perfil/PerfilDirectivo'
import EditarPerfil from './views/commons/EditarPerfil/EditarPerfil'
import DanielFlores from './views/componentPreview/DanielFlores/DanielFlores'
import DanielMaldonado from './views/componentPreview/DanielMaldonado/DanielMaldonado'
import DanielMunive from './views/componentPreview/DanielMunive/DanielMunive'
import Ezequiel from './views/componentPreview/Ezequiel/Ezequiel'
import Fernando from './views/componentPreview/Fernando/Fernando'

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

        <Route path='/danielFlores' element={<DanielFlores/>} />
        <Route path='/danielMaldonado' element={<DanielMaldonado/>} />
        <Route path='/danielMunive' element={<DanielMunive/>} />
        <Route path='/ezequiel' element={<Ezequiel/>} />
        <Route path='/fernando' element={<Fernando/>} />

        {/* Esta última ruta es a donde se redirige al usuario cuando se busca una ruta inexistente */}
        <Route path='*' element={<TemporalHome />} />
      </Routes>
    </Router>
  );
}

export default App;

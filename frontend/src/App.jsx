import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import TemporalHome from './views/componentPreview/TemporalHome/TemporalHome';
import LandingPage from './views/LandingPage/LandingPage';
import Calendario from './views/commons/Calendario/Calendario';

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path='/' element={<TemporalHome />} />
        <Route path='/landingPage' element={<LandingPage />} />
        <Route path='/calendario' element={<Calendario/>} />
        <Route path='*' element={<TemporalHome />} />
      </Routes>
    </Router>
  );
}

export default App;

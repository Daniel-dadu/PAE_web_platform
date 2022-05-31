import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import './BotonCambioPerfil.css'



function BotonCambioPerfil() {

  const navigate = useNavigate()

  const [asesorClicked, setAsesorClicked] = useState(localStorage.rolUsuario === 'asesor' ? true : false)

  // Hook para hacer el cambio de tipo de perfil
  useEffect(() => {
    if(!asesorClicked && localStorage.rolUsuario === 'asesor') {
      localStorage.setItem('rolUsuario', 'asesorado')
      localStorage.setItem('usuarioAsesor', 'true')
      navigate('/perfilAsesorado')
    } else if(asesorClicked && localStorage.rolUsuario === 'asesorado') {
      localStorage.setItem('rolUsuario', 'asesor')
      navigate('/perfilAsesor')
    }
  }, [asesorClicked, navigate])

  return (

    <div className="contenedorBotonCambioPerfil">

      <button onClick={() => setAsesorClicked(false)} style={
        {
          backgroundColor: asesorClicked ? 'white' : '#50C7F1',
          borderRadius: '10px 0px 0px 0'
        }
      }>
        Alumno
      </button>

      <button onClick={() => setAsesorClicked(true)} style={
        {
          backgroundColor: asesorClicked ? '#50C7F1' : 'white',
          borderRadius: '0px 10px 0px 0'
        }
      }>
        Asesor
      </button>  

    </div>

  );
}
  
  

export default BotonCambioPerfil


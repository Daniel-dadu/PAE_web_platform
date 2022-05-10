import React, {useState} from 'react'

import './BotonCambioPerfil.css'



function BotonCambioPerfil() {


  return (

    

    <div className="contenedorBotonCambioPerfil">
      

      <label for="perfilChoice1" >
          <input type="radio" id="Asesorado" name="TipoUsuario" value="Asesorado" checked />
          <span
            style={{
              position: "relative",
              left: "18px",
              top: "-35px",
              fontSize: "20px"
            }}
          >
            Alumno
          </span>
        </label>

        <label for="perfilChoice2">
          <input type="radio" id="Asesor" name="TipoUsuario" value="Asesor" checked />
          <span
            style={{
              position: "relative",
              left: "25px",
              top: "-35px",
              fontSize: "20px"
            }}
          >
            Asesor
          </span>
        </label>
    </div>




  );
}
  
  

export default BotonCambioPerfil


import React, { useState } from 'react'
import './CampoTextoPequeno.css'

import { HiEye, HiEyeOff } from 'react-icons/hi'

// Descripción de las propedades
/*
size: se recibe un string que puede ser "small", "medium" o "big"
*/


function CampoTextoPequeno({ size, onInsertText, maxNumCaracteres="1000", previousText="", isPassword=false }) {

  const [visiblePassword, setVisiblePassword] = useState(isPassword)

  return (
    <div className="container_ctp">
        <input 
          type={visiblePassword ? "password" : "text"} 
          maxLength={ maxNumCaracteres }
          defaultValue={ previousText }
          style={{width: size === "small" ? "150px" : size === "medium" ? "350px" :  size === "big" ? "600px" : "80%" }} 
          onChange={(input) => onInsertText(input.target.value)} 
        />
        { // Código para comprobar si el campo de texto es una contraseña y, en caso de que sí, mostrar el ícono adecuado
          isPassword && (visiblePassword ? 
            <HiEye size={25} className='password_visibility_icon' onClick={() => setVisiblePassword(!visiblePassword)} /> 
            :
            <HiEyeOff size={25} className='password_visibility_icon' onClick={() => setVisiblePassword(!visiblePassword)} />)
        }
    </div>
  )
}

export default CampoTextoPequeno
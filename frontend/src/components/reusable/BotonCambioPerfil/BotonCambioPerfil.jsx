import React, {useState} from 'react'

import './BotonCambioPerfil.css'

function BotonCambioPerfil() {

  const [ gender , setGender ] = useState("girl")

  const changeGender = () => {
    if(gender === "girl") {
      setGender("boy")
    } else setGender("girl")
  }

  const genderBtn = gender === "girl" ?
  <h2 onClick={changeGender} style={{
    backgroundColor: "pink",
    width: "100px",
    padding: "2px",
    borderRadius: "100px",
    cursor: "pointer",
  }}>{gender}</h2>
  :
  <h2 onClick={changeGender} style={{
    backgroundColor: "lightblue",
    width: "100px",
    padding: "2px",
    borderRadius: "100px",
    cursor: "pointer",
  }}>{gender}</h2>

  return (
    <div className="App">
      {genderBtn}
    </div>
  );
}
  
  

export default BotonCambioPerfil


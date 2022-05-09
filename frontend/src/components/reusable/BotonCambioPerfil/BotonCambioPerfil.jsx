import React, {useState} from 'react'

import './BotonCambioPerfil.css'

function BotonCambioPerfil() {

    const [gender, setGender] = React.useState('Famale');

    const handleCatChange = () => {
        setGender('Male');
      };
    
      const handleDogChange = () => {
        setGender('Female');
      };

  return (
    <div className='contenedorBotonCambioPerfil'>

    <RadioButton
        label="Male"
        value={gender === 'Male'}
        onChange={handleCatChange}
      />
      <RadioButton
        label="Female"
        value={gender === 'Female'}
        onChange={handleDogChange}
      />
        
        </div>
  )
}

const RadioButton = ({ label, value, onChange }) => {
    return (
      <label>
        <input type="radio" checked={value} onChange={onChange} />
        {label}
      </label>
    );
  };
  
  

export default BotonCambioPerfil


import React from 'react'

import './BotonAdministrarInformacion.css'


            // eslint-disable-next-line no-lone-blocks
            {/*  <BotonAdministrarInformacion 
            onClick={() => {alert('Me diste click :)')}}  Lo que quieras que haga el OnClick
            Imagen={Logo} La imagen que debe aparece
            children='Respuestas de encuestas a asesorados'> Texto que quieras que salga en el boton

            </BotonAdministrarInformacion>  */}

function BotonAdministrarInformacion({ onClick, Imagen, children, name }) {
  return (
      
    <button className='botonPruebaEren' onClick = {onClick}> 

             <div> 
                
             <img 
            className='botonAdministrarImagen'
            src = {Imagen} 
            alt = {name}/>  

             <p className='botonAdministrarTextoDefinicion'>
                 {children}
                 </p>  

            </div> 

        </button>
  

  )
}

export default BotonAdministrarInformacion
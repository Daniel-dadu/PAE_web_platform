import React from 'react';
import { BotonSencillo } from '../../../routeIndex';
import { Template, BarraProgreso, TarjetaMaestraMini } from '../../../routeIndex'
import './popUpGeneral.css';



const PopUpGeneral = (  ) => {

  const saludar = () => {
    window.alert("hola");
  }

  return (
    <>
        
        <div className='contenedorGeneral-PopUpGeneral'>

          <div className='contenedor-PopUpGeneral'>
              <div className='parte-arriba-PopUpGeneral'>
                  <p className='texto-PopUpGeneral'> Tu reserva se realizó exitosamente </p>
              </div>
              <div className='parte-abajo-PopUpGeneral'>
                  <BotonSencillo onClick={ saludar } backgroundColor="verde" size="normal"  children="Entendido" />
              </div>
          </div>

        </div>
  
        
    </>
  )
}

export default PopUpGeneral
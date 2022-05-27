import React from 'react'

import './PerfilDirectivo.css'

import { Perfil, BotonSencillo } from '../../../routeIndex'


function PerfilDirectivo() {
  return (

    <Perfil>
        <div className='btonDescargarEstadiPerfilDirectivo'>
            <BotonSencillo onClick={() => alert("Pronto estará lista esta funcionalidad")} backgroundColor='verde' size='grande'>
                Descargar Estadisticas Generales
            </BotonSencillo>
        </div>
    </Perfil>
    
  )
}

export default PerfilDirectivo
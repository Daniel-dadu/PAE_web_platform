import React from 'react';
import './perfilAsesorado.css';

import { Perfil, BotonCambioPerfil } from '../../../routeIndex';

function PerfilAsesorado() {
  return (
    <Perfil>
      {
        localStorage.usuarioAsesor &&
        <div className = 'containerBtnCambioTipoUsuario'>
          <BotonCambioPerfil />
        </div>
      }
    </Perfil>
  )
}

export default PerfilAsesorado
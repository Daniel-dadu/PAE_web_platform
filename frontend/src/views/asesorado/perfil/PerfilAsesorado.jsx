import React, {useState} from 'react';
import './perfilAsesorado.css';

import { Perfil, BotonCambioPerfil, PopUpEncuesta } from '../../../routeIndex';

function PerfilAsesorado() {

  const [activoEncuesta, setActivoEncuesta] = useState(false);

  const cerrarEncuesta = () => setActivoEncuesta(!activoEncuesta)

  const data = [
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
    },
    {
        tipoDePregunta:"abierta",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
    }
  ]
  
  return (
    <>
      <PopUpEncuesta tipo={1} nombreEvaluado="Daniel Maldonado" preguntas={ data } activo={activoEncuesta} ocultarPopUp={cerrarEncuesta} />
      <Perfil>
        {
          localStorage.usuarioAsesor &&
          <div className = 'containerBtnCambioTipoUsuario'>
            <BotonCambioPerfil />
          </div>
        }


        {/* Código temporal - eliminar después */}
        <button onClick={ cerrarEncuesta } style={{width:200, height:60, backgroundColor:'grey', color: 'white', borderRadius: '20px', margin: 'auto', display: 'block', cursor: 'pointer', fontSize: '1.5rem', marginTop: '3rem' }}> 
          Mostrar Encuesta 
        </button>

      </Perfil>

    </>
  )
}

export default PerfilAsesorado
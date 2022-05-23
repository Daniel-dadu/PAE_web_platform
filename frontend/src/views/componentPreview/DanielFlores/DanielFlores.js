import React, { useState } from 'react'
import { Template, ListaUnidadesDeFormacionAsesor, PopUpEncuesta } from '../../../routeIndex'
import './danielFlores.css';



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

const data2 = [
  {
      tipoDePregunta:"cerrada",
      pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
      respuesta: 9

  },
  {
      tipoDePregunta:"cerrada",
      pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
      respuesta: 3
  },
  {
      tipoDePregunta:"abierta",
      pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
      respuesta: "Mucho texto muy explicito."
  },
  {
      tipoDePregunta:"cerrada",
      pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
      respuesta: 6

  },
  {
      tipoDePregunta:"cerrada",
      pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
      respuesta: 8

  }

]

const DanielFlores = () => {

  const [activoEncuesta, setActivoEncuesta] = useState(true);

const cerrarEncuesta = () => {
    setActivoEncuesta(!activoEncuesta);
    
}

  return (
    <>
        <PopUpEncuesta tipo={1} nombreEvaluado="Daniel Maldonado" preguntas={ data } activo={activoEncuesta} ocultarPopUp={cerrarEncuesta} />
        
        <Template view="perfil">

          
          <div className='div-prueba-df'>
            <button onClick={ cerrarEncuesta }> Abrir PupUpEncuesta </button>
          </div> 



        </Template>


    </>
  )
}

export default DanielFlores
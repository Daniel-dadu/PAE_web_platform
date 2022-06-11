import React, { useState } from 'react'

import './PreguntaAbiertaEncuesta.css'
import {  CampoTextoGrande } from '../../../routeIndex'



// eslint-disable-next-line no-lone-blocks
{/* <PreguntaAbiertaEncuesta 

preguntaAbierta={'Aqui pon la pregunta que quieras'}>

</PreguntaAbiertaEncuesta> */}

function PreguntaAbiertaEncuesta({preguntaAbierta, idPregunta, getRespuesta, respuesta=''}) {

    const [respuestaUser, setRespuestaUser] = useState(respuesta)

    const handleRespuesta = res => {
        if(respuesta === '') {
            setRespuestaUser(res)
            getRespuesta(res, idPregunta)
        }
    }

    return (
        <div className='contenedorPreguntaAbiertaEncuesta'>
            <div className='textoPreguntaAbiertaEncuesta'> {preguntaAbierta} </div>
            <div> 
                <CampoTextoGrande parentCallback={handleRespuesta} defaultText={respuestaUser}/> 
            </div>
        </div>
    )
}

export default PreguntaAbiertaEncuesta
import React, { useEffect, useState } from 'react'
import './AgendarAsesoriaHora.css'
import { useParams, useNavigate } from "react-router-dom"
import axios from 'axios'

import { AgendarAsesoria, SeleccionarHorarioAsesoria, dateFunctions } from '../../../routeIndex'

let progressBar = {
  "currentStep": 3,
  "steps": [
      {
          "name" : "Selección",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        }, 
        {
          "name" : "Información",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Fecha",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Hora",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
      }
  ]
}
function AgendarAsesoriaHora() {

  const { anio, mes, dia } = useParams();

  const navigate = useNavigate()

  useEffect(() => {
    // Si no se seleccionó una asesoría, se redirecciona al usuario a la primera pantalla
    if(!localStorage.asesoria_uf) {
      navigate('/agendarAsesoriaUF/error')
    }
  })

  const [horasDisponibles, setHorasDisponibles] = useState({
    day : "Cargando...",
    hours : []
  })

  useEffect(() => {
    var config = {
      method: 'get',
      url: `http://20.225.209.57:3094/asesoria/get_horas/?uf=${localStorage.asesoria_uf}&anio=${anio}&mes=${mes}&dia=${dia}`,
      headers: { }
    };
    
    axios(config)
    .then(response => {
      setHorasDisponibles({
        day: dia + " de " + dateFunctions.getMonthEspanol(mes-1),
        hours: response.data.horas_disponibles.map(hora => hora + ":00")
      })
    })
    .catch(_error => {
      setHorasDisponibles({
        day: "Error, intente con otro día",
        hours: []
      })
    })

  }, [setHorasDisponibles, anio, mes, dia])

  return (
    <AgendarAsesoria 
    showAtrasBtn={true} 
    btnAtrasRoute="./AgendarAsesoriaCalendario" 
    btnSiguienteRoute="./AgendarAsesoriaResumen"
    showTarjetaMaestraMini={true} 
    sizeTarjetaMaestraMini="normal" 
    progressBarJSON={progressBar}>
        <div className='horario_container'>
          <SeleccionarHorarioAsesoria date={horasDisponibles}/>
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaHora
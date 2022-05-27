import React, { useEffect, useState } from 'react'
import './AgendarAsesoriaHora.css'
import { useParams, useNavigate } from "react-router-dom"
import axios from 'axios'

import { AgendarAsesoria, SeleccionarHorarioAsesoria, dateFunctions } from '../../../routeIndex'

function AgendarAsesoriaHora() {

  const { anio, mes, dia } = useParams();

  const progressBar = {
    "currentStep": 3,
    "steps": [
      {
        "name" : "Selección",
        "state": true,
        "next": "enable",
        "path" : "/AgendarAsesoriaUF/ok"
      }, 
      {
        "name" : "Información",
        "state": true,
        "next": "enable",
        "path" : "/AgendarAsesoriaDuda"
      },
      {
        "name" : "Fecha",
        "state": true,
        "next": "enable",
        "path" : "/AgendarAsesoriaCalendario"
      },
      {
        "name" : "Hora",
        "state": true,
        "next": "enable",
        "path" : `/AgendarAsesoriaHora/${anio}/${mes}/${dia}`
      },
      {
        "name" : "Confirmación",
        "state": null,
        "next": "enable",
        "path" : `/AgendarAsesoriaHora/${anio}/${mes}/${dia}`
      }
    ]
  }

  const navigate = useNavigate()

  useEffect(() => {
    // Si no se seleccionó una asesoría, se redirecciona al usuario a la primera pantalla
    if(!localStorage.asesoria_uf) {
      navigate('/agendarAsesoriaUF/error')
      return
    }
  }, [navigate])

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


  const [horaSeleccionada, setHoraSeleccionada] = useState(null)

  const handleHoraSeleccionada = (hora) => {
    setHoraSeleccionada(hora)
  }

  return (
    <AgendarAsesoria 
    showAtrasBtn={true} 
    btnAtrasRoute="./AgendarAsesoriaCalendario" 
    btnSiguienteProps={{view: 4, props: {horaSeleccionada, dia, mes, anio}}}
    showTarjetaMaestraMini={true} 
    sizeTarjetaMaestraMini="normal" 
    progressBarJSON={progressBar}>
        <h2 className='title_instructions_agendarAsesoria'>
          Selecciona el horario que más te resulte conveniente
        </h2>
        <h4 className='subtitle_instructions_agendarAsesoria'>
          Los horarios en color <span style={{color: "red", fontWeight: '400'}}>rojo</span> no están disponibles
        </h4>

        <div className='horario_container'>
          <SeleccionarHorarioAsesoria date={horasDisponibles} parentCallback={handleHoraSeleccionada} />
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaHora
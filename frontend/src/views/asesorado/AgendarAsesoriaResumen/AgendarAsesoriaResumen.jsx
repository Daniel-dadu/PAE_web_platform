import React, {useEffect} from 'react'
import './AgendarAsesoriaResumen.css'
import { useNavigate } from "react-router-dom"

import { AgendarAsesoria, TarjetaInformacion, dateFunctions } from '../../../routeIndex'

let progressBar = {
  "currentStep": 4,
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
          "state": true,
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
function AgendarAsesoriaResumen() {

  const navigate = useNavigate()

  const ufSelected = localStorage.asesoria_uf
  const anioSelected = localStorage.asesoria_anio
  const mesSelected = localStorage.asesoria_mes
  const diaSelected = localStorage.asesoria_dia
  const horaSelected = localStorage.asesoria_hora
  const dudaSelected = localStorage.asesoria_duda
  const imagesSelected = [localStorage.asesoria_imagen1, localStorage.asesoria_imagen2, localStorage.asesoria_imagen3]

  useEffect(() => {
    // Si no se cuenta con los datos necesarios, se redirecciona al usuario a la primera pantalla
    if(!ufSelected || !anioSelected || !mesSelected || !diaSelected || !horaSelected) {
      navigate('/agendarAsesoriaUF/error')
    }
  }, [ufSelected, anioSelected, mesSelected, diaSelected, horaSelected, navigate])

  return (
  <AgendarAsesoria 
    showAtrasBtn={true} 
    btnAtrasRoute={`./agendarAsesoriaHora/${anioSelected}/${mesSelected}/${diaSelected}`}
    btnSiguienteProps={
    {
      view: 5, 
      props: { ufSelected, anioSelected, mesSelected, diaSelected, horaSelected, dudaSelected, imagesSelected }
    }}
    showTarjetaMaestraMini={true} 
    sizeTarjetaMaestraMini="normal" 
    progressBarJSON={progressBar}>
        <h4 className='subtitle_instructions_agendarAsesoria'>Verifica que la información esté correcta antes de continuar</h4>

        <div className='resumen_container'>
          <TarjetaInformacion info={
            [ 
              { title: "Unidad de formación", info: ufSelected },
              { title: "Fecha", info: diaSelected + " de " + dateFunctions.getMonthEspanol(mesSelected-1) + " del " + anioSelected },
              { title: "Hora", info: horaSelected },
              { title: "Duda", info: dudaSelected },
              { title: "Fotos", info: imagesSelected },
            ]
          }/>
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaResumen
import React, {useState, useEffect} from 'react'
import './AgendarAsesoriaResumen.css'
import { useNavigate } from "react-router-dom"

import { AgendarAsesoria, TarjetaInformacion, dateFunctions } from '../../../routeIndex'
import axios from 'axios'


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

  const progressBar = {
    "currentStep": 4,
    "steps": [
        {
            "name" : "Selección",
            "state": true,
            "next": "enable",
            "path" : "./AgendarAsesoriaUF/ok"
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
            "path" : "./AgendarAsesoriaCalendario"
          },
          {
            "name" : "Hora",
            "state": true,
            "next": "enable",
            "path" : `./AgendarAsesoriaHora/${anioSelected}/${mesSelected}/${diaSelected}`
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "./AgendarAsesoriaResumen"
        }
    ]
  }

  // Hook para establecer el nombre completo de la UF una vez que se obtenga de la API
  const [nombreUF, setNombreUF] = useState(null)

  // Hook para hacer la consulta del nombre completo de la UF a partir de su id
  useEffect(() => {
    const config = {
      method: 'get',
      url: `http://20.225.209.57:3091/general/nombre_uf?id_uf=${ufSelected}`,
      headers: { }
    }
    
    // Cuando se obtenga el nombre de la UF, se agrega en el hook 'nombreUF'
    axios(config).then(response => {
      setNombreUF(response.data.nombreUF)
    })

  }, [ufSelected, setNombreUF])

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
    isResumenView={true}
    progressBarJSON={progressBar}>
        <h4 className='subtitle_instructions_agendarAsesoria'>Verifica que la información esté correcta antes de continuar</h4>

        <div className='resumen_container'>
          <TarjetaInformacion info={
            [ 
              { title: "Unidad de formación", info: ufSelected + (nombreUF ? ` - ${nombreUF}` : '') },
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
import React, {useState} from 'react'
import { TemplateRegistroUsuario, InformacionPersonalUsuario, ListaUnidadesDeFormacionAsesor, CambioMesPeriodo, CalendarioDisponibilidad } from '../../../routeIndex'
import "./RegistroAsesorResumen.css"
import dateFunctions from '../../../assets/reusableFunctions/dateFunctions.js'

let progressBar = {
  "currentStep": 4,
  "steps": [
      {
          "name" : "Datos Generales",
          "state": true,
          "next": "enable",
          "path" : "/registroAsesorDatos"
        }, 
        {
          "name" : "Horario",
          "state": true,
          "next": "enable",
          "path" : "Ruta"
        },
        {
          "name" : "Unidad de Formacion",
          "state": true,
          "next": "enable",
          "path" : "Ruta"
        },
        {
          "name" : "Consideraciones Finales",
          "state": true,
          "next": "enable",
          "path" : "./registroAsesorCondiciones"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "./registroAsesorResumen"
        }
  ]
}

const listaUF = [
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:1
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:1
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:2
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:2
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        }
    }
  
]

function RegistroAsesorResumen() {

    // Variable para conocer la fecha de hoy y actualizar el año
    const [today, setToday] = useState(new Date())

    // Variable de tipo objeto para actuazlizar los valores del mes y año
    const [mesAnio, setmesAnio] = useState(
        {
        mes: dateFunctions.getMonthEspanol(today.getMonth()),
        anio: today.getFullYear()
        }
    )

    // Función que maneja se ejecuta cuando se da click a una flecha del componente CambioMesPeriodo
    // Recibe como parámetro el tipo de botón al que se le dió click y cambia el valor de 'mesAnio' y 'today'
    const handleArrowClick = arrow => {
        let currentMonth = mesAnio.mes
        if(currentMonth === 'Diciembre' && arrow === 'next') {
        setmesAnio(
            {
            mes: 'Enero',
            anio: today.getFullYear()+1
            }
        )
        setToday(new Date(today.getFullYear()+1, today.getMonth(), today.getDate()))
        } else if (currentMonth === 'Enero' && arrow === 'back') {
        setmesAnio(
            {
            mes: 'Diciembre',
            anio: today.getFullYear()-1
            }
        )
        setToday(new Date(today.getFullYear()-1, today.getMonth(), today.getDate()))
        } else {
        setmesAnio(
            {
            mes: dateFunctions.getMonthEspanol(
                arrow === 'next' ? dateFunctions.monthsEnNumero[currentMonth]+1 :
                dateFunctions.monthsEnNumero[currentMonth]-1
            ),
            anio: today.getFullYear()
            }
        )
        }
    }

    return (
        
        <TemplateRegistroUsuario 
            progressBarJSON = {progressBar}
            btnAtrasRoute = "./registroAsesorCondiciones"
            btnSiguienteProps={{ view: 5, props: null }}
            isRegistroAsesor={true}
        >

            <h1> Resumen de información </h1>

            <div className = 'containerPerfilAsesoradoResumen'>
                <InformacionPersonalUsuario>
                </InformacionPersonalUsuario>
            </div>

            <div className = 'containerListaUFResumen'>
                <ListaUnidadesDeFormacionAsesor data = {listaUF} />
            </div>

            <div className = 'containerCambioMesPeriodoResumen'>
                <CambioMesPeriodo dataSupInf={{textoSuperior: mesAnio.mes, textoInferior: mesAnio.anio}} onClickArrow={handleArrowClick}/>
            </div>

            <div className = 'containerCalendarioDisponibilidadResumen'>
                <CalendarioDisponibilidad/>
            </div>

        </TemplateRegistroUsuario>

  )
}

export default RegistroAsesorResumen
import React, {useEffect, useState} from 'react'
import { TemplateRegistroUsuario, ListaDesplegable, TarjetaListaDesplegable, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'

import axios from 'axios'

import '../../../index.css'
import "./RegistroAsesorUF.css"

let progressBar = {
  "currentStep": 2,
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
          "state": null,
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

function RegistroAsesorUF(){

    const [CONSTplanEstudiosAPI, setCONSTPlanEstudiosAPI] = useState([])

    const [planEstudiosAPI, setPlanEstudiosAPI] = useState([])

    const [UFSelected, setUFSelected] = useState([])

    useEffect(() => {
        const config = {
            method: 'get',
            url: `http://20.225.209.57:3091/general/get_ufs_carreras?carrera1=${localStorage.registro1_carrera}&carrera2=${
                localStorage.registro1_carrera2 ? localStorage.registro1_carrera2 : null
            }`,
            headers: { }
        }
          
        axios(config)
        .then(response => {
            setCONSTPlanEstudiosAPI(response.data)
            setPlanEstudiosAPI(response.data)

            // Varificamos si hay UFs en el localStorage
            if(localStorage.registro1_UFs) {
                let previousUFs = JSON.parse(localStorage.registro1_UFs) // Obtenemos la lista de UFs previamente seleccionada
                // Establecemos las UFs correctas
                setUFSelected(
                    // Filtramos las UFs verificando que cada una de las seleccionadas esté en las materias de la carrera actual
                    previousUFs.filter(ufPrev => {
                        for(let ufCarrera of response.data[ufPrev.semestre-1].unidadesFormacion) // Variante del For Each 
                            if(ufCarrera.claveUF === ufPrev.claveUF) 
                                return true

                        return false
                    })
                )
            }

        })
        .catch(_error => {
            alert("Error: no se pudieron cargar las Unidades de formación, intente de nuevo más tarde")
        })
    }, [setPlanEstudiosAPI, setCONSTPlanEstudiosAPI])


    // Función que recibe el semestre seleccionado en el componente "CampoSeleccionarEnListaDesplegable"
    const handleSemestreFilter = semestreValue => {
        const semestreStr = semestreValue.value
        const semestreInt = semestreStr ? parseInt(semestreStr[semestreStr.length - 1]) : null

        setPlanEstudiosAPI( semestreStr && semestreInt ?
            [CONSTplanEstudiosAPI[semestreInt - 1]] : 
            CONSTplanEstudiosAPI
        )
    }


    const onSelectUF = infoUF => {

        const ufAlreadySelected = UFSelected.find(uf => uf.claveUF === infoUF.claveUF)

        // Si la UF ya había sido seleccionada, se elimina. Si no, se agrega al array de UFSelected
        setUFSelected(
            ufAlreadySelected ?
            UFSelected.filter(uf => uf.claveUF !== infoUF.claveUF) :
            [...UFSelected, infoUF]
        )
    }

    const onDeleteUF = claveUF => setUFSelected(UFSelected.filter(uf => uf.claveUF !== claveUF))


    return (
        
        <TemplateRegistroUsuario 
            progressBarJSON = {progressBar}
            btnAtrasRoute = "./registroAsesorHorario"
            btnSiguienteProps={{ view: 3, props: UFSelected }}
            isRegistroAsesor={true}
        >

            <div className='bloq_condicionesAsesor'>
                <h1 className='campo_RegistroAsesorCondiciones'> CAMPO 3: Selecciona las materias en las que quieres dar asesorías </h1>
            </div>

            <div className = 'containerUnidadesFormacion'>

                <div className = 'containerSeleccionUF'>
                    
                    <div className = 'containerSeleccionBusquedaUF'>

                        <div className = 'containerSeleccionPeriodo'>
                            <CampoSeleccionarEnListaDesplegable 
                                placeholder = 'Seleccionar semestre' 
                                size = "medium" 
                                options = {[1,2,3,4,5,6,7,8,9].map(i => `Semestre ${i}`)} 
                                parentCallback = {handleSemestreFilter}
                            />
                        </div>
                        
                    </div>

                    <div className='list_ufsBySemester'>

                        {
                            Object.keys(planEstudiosAPI).map((index) => 
                                <div className = {`containerListaDesplegableAsesorias listaDesplegableSemestre-${planEstudiosAPI[index]['semestre']}`} key={index} >
                                    <ListaDesplegable
                                        fecha = {`Semestre ${planEstudiosAPI[index]['semestre']}`}
                                        tipo = {1}
                                        semestre={planEstudiosAPI[index]['semestre']}
                                        arrContenido = {planEstudiosAPI[index]['unidadesFormacion']}
                                        getUFSelected={ onSelectUF }
                                    />
                                </div>
                            )
                        }

                    </div>

                    
                </div>

                <div className = 'containerMateriasSeleccionadas'>

                    <h2> Materias seleccionadas </h2>
                    
                    {/*Esto se debe realizar dinámicamente, cuando DANO agregue el atributo onClick a las tarjetas de la ListaDesplegable*/}

                    <div className='list_selectedUFs'>

                        {  
                            UFSelected.map((UF, index) => 
                                <div className = 'containerMateriaSeleccionada' key={index} >
                                    <TarjetaListaDesplegable
                                        tipo = {2}
                                        semestre = {UF.semestre}
                                        claveUF = {UF.claveUF}
                                        nombreUF = {UF.nombreUF}
                                        getUFSelected = { onDeleteUF }
                                    />
                                </div>
                            )
                        }

                    </div>

                </div>

            </div>

        </TemplateRegistroUsuario>
  )
}

export default RegistroAsesorUF
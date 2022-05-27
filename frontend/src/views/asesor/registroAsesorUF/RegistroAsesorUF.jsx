import React, {useState} from 'react'
import { TemplateRegistroUsuario, ListaDesplegable, TarjetaListaDesplegable, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'
import planEstudiosJSON from './PruebaRegistroAsesorUF.json'
import '../../../index.css'
import "./RegistroAsesorUF.css"
import { FaSearch } from "react-icons/fa";

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

function RegistroAsesorUF({planEstudios = planEstudiosJSON}){

    // Hook para guardar el periodo seleccionado
    const [periodoSeleccionado, setPeriodoSeleccionado] = useState(null)
    
    if(periodoSeleccionado === 0){
        console.log(periodoSeleccionado);
    }

    // Función que recibe el periodo seleccionado en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a carreraSeleccionada
    const handlePeriodo = periodoValue => {
        setPeriodoSeleccionado(periodoValue.value)
    }

    return (
        
        <TemplateRegistroUsuario 
            progressBarJSON = {progressBar}
            btnAtrasRoute = "./registroAsesorHorario"
            btnSiguienteProps={{ view: 3, props: null }}
            isRegistroAsesor={true}
        >

            <div className='bloq_condicionesAsesor'>
                <h1 className='campo_RegistroAsesorCondiciones'> CAMPO 3: Selecciona las materias en las que quieres dar asesorías </h1>
            </div>

            <div className = 'containerUnidadesFormacion'>

                <div className = 'containerSeleccionUF'>
                    
                    <div className = 'containerSeleccionBusquedaUF'>

                        <div className = 'containerSeleccionPeriodo'>
                            <CampoSeleccionarEnListaDesplegable defectValue = 'Periodo' size = "medium" options = {[1, 2, 3]} parentCallback = {handlePeriodo}/>
                        </div>
                        
                        <div className = 'barraBusquedaRegistroUF'>

                            <div className = 'containerBarraBusqueda'>
                                <input type = 'text' placeholder = {`Buscar unidad de formación`} />
                                <FaSearch className = 'icono'/>
                            </div>

                        </div>

                    </div>

                    {
                        Object.keys(planEstudios['planEstudios']).map((index) => {
                            return(
                                <>
                                <div className = {`containerListaDesplegableAsesorias listaDesplegableSemestre-${planEstudios['planEstudios'][index]['semestre']}`}>
                                    <ListaDesplegable
                                        fecha = {`Semestre ${planEstudios['planEstudios'][index]['semestre']}`}
                                        tipo = {2}
                                        arrContenido = {planEstudios['planEstudios'][index]['unidadesFormacion']}
                                    />
                                </div>
                                </>
                            )
                        })
                    }
                    
                </div>

                <div className = 'containerMateriasSeleccionadas'>

                    <h2> Materias seleccionadas </h2>
                    
                    {/*Esto se debe realizar dinámicamente, cuando DANO agregue el atributo onClick a las tarjetas de la ListaDesplegable*/}

                    <div className = 'containerMateriaSeleccionada'>
                        <TarjetaListaDesplegable
                            tipo = {2}
                            semestre = {1}
                            claveUF = 'TC3005B'
                            nombreUF = 'Desarrollo de software'
                        />
                    </div>

                    <div className = 'containerMateriaSeleccionada'>
                        <TarjetaListaDesplegable
                            tipo = {2}
                            semestre = {2}
                            claveUF = 'TC3005B'
                            nombreUF = 'Desarrollo de software'
                        />
                    </div>

                    <div className = 'containerMateriaSeleccionada'>
                        <TarjetaListaDesplegable
                            tipo = {2}
                            semestre = {3}
                            claveUF = 'TC3005B'
                            nombreUF = 'Desarrollo de software'
                        />
                    </div>

                </div>

            </div>

        </TemplateRegistroUsuario>

  )
}

export default RegistroAsesorUF
import React, {useState} from 'react'
import { TemplateRegistroUsuario, ListaDesplegable, TarjetaListaDesplegable, CampoSeleccionarEnListaDesplegable } from '../../../routeIndex'
import planEstudiosJSON from './PruebaRegistroAsesorUF.json'
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

function RegistroAsesorUF({planEstudios = planEstudiosJSON}){

    // Hook para guardar el periodo seleccionado
    const [semestreFilter, setSemestreFilter] = useState(null)

    // Función que recibe el periodo seleccionado en el componente "CampoSeleccionarEnListaDesplegable" y asigna el valor a carreraSeleccionada
    const handleSemestreFilter = semestreValue => {
        setSemestreFilter(semestreValue.value)
        console.log(semestreFilter)
    }

    return (
        
        <TemplateRegistroUsuario 
            progressBarJSON = {progressBar}
            btnAtrasRoute = "./registroAsesorHorario"
            btnSiguienteProps={{ view: 3, props: "pendiente" }}
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

                    {
                        Object.keys(planEstudios['planEstudios']).map((index) => 
                            <div className = {`containerListaDesplegableAsesorias listaDesplegableSemestre-${planEstudios['planEstudios'][index]['semestre']}`}>
                                <ListaDesplegable
                                    fecha = {`Semestre ${planEstudios['planEstudios'][index]['semestre']}`}
                                    tipo = {2}
                                    arrContenido = {planEstudios['planEstudios'][index]['unidadesFormacion']}
                                />
                            </div>
                        )
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
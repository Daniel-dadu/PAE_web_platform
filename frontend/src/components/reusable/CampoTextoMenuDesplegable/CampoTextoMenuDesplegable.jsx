import React, {useState} from 'react' // Agregar uso de {useState}
import '../../../index.css'
import './CampoTextoMenuDesplegable.css'
import { ListaDesplegable } from '../../../routeIndex'

var gruposJSON = {
    "grupos": [
        {
            "claveUF":"",
            "colorTipo3":"gris_tipo_1",
            "horaAsesoria":"",
            "contenido":"Todos"
        },
        {
            "claveUF":"",
            "colorTipo3":"gris_tipo_1",
            "horaAsesoria":"",
            "contenido":"Estudiantes"
        },
        {
            "claveUF":"",
            "colorTipo3":"gris_tipo_1",
            "horaAsesoria":"",
            "contenido":"Asesores"
        }
    ]
}

const CampoTextoMenuDesplegable = ({
    getGroup // JSON con el nombre y matrícula de cada usuario del sistema
}) => {
    
    const [currentSelection, setCurrentSelection] = useState('TODOS');
    
    // DANO debe agregar el evento onClick en cada tarjeta, para después
    // pasar por parámetro el setter del useState: onClick = {() => {setCurrentSelection('hola')}}
    // para que se seleccione un grupo o usuario específico

    const onSelectGrupo = grupo => {
        getGroup(grupo);
        setCurrentSelection(grupo);
        
    }

    return(
        <>
        <div className = 'containerCampoTextoMenuDesplegable'>
            <div className = 'containerSeleccionMenuDesplegable'>
                <button> {currentSelection} </button>
            </div>
            <div className = 'containerListaMenuDesplegable-1'>
                <ListaDesplegable
                    fecha = 'Grupos'
                    tipo = {2}
                    arrContenido = {gruposJSON.grupos}
                    isSend = {1}
                    getGrupoSelected = {onSelectGrupo}
                />
            </div>
            {/* <div className = 'containerListaMenuDesplegable-2'>
                <ListaDesplegable
                    fecha = 'Usuarios'
                    tipo = {2}
                    arrContenido = {getGroup['usuarios']}
                />
            </div> */}
        </div>
        </>
    );

};

export default CampoTextoMenuDesplegable
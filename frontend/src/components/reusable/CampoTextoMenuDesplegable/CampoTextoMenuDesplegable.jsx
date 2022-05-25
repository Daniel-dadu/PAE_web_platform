import React from 'react' // Agregar uso de {useState}
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
    usuariosJSON // JSON con el nombre y matrícula de cada usuario del sistema
}) => {
    
    // const [currentSelection, setCurrentSelection] = useState('Todos');
    
    // DANO debe agregar el evento onClick en cada tarjeta, para después
    // pasar por parámetro el setter del useState: onClick = {() => {setCurrentSelection('hola')}}
    // para que se seleccione un grupo o usuario específico

    return(
        <>
        <div className = 'containerCampoTextoMenuDesplegable'>
            <div className = 'containerSeleccionMenuDesplegable'>
                <button> Todos </button>
            </div>
            <div className = 'containerListaMenuDesplegable-1'>
                <ListaDesplegable
                    fecha = 'Grupos'
                    tipo = {2}
                    arrContenido = {gruposJSON.grupos}
                />
            </div>
            <div className = 'containerListaMenuDesplegable-2'>
                <ListaDesplegable
                    fecha = 'Usuarios'
                    tipo = {2}
                    arrContenido = {usuariosJSON['usuarios']}
                />
            </div>
        </div>
        </>
    );

};

export default CampoTextoMenuDesplegable
import React  from 'react'
import '../../../index.css'
import './AdministrarUsuariosDirectivos.css'
import { useNavigate } from "react-router-dom";
import { Template, ListaUsuarios, BotonSencillo, BotonConImagen } from '../../../routeIndex'

import { FaCopy} from 'react-icons/fa'

const dataUsuarios = [
    {
        "matricula": "A00000001",
        "nombreCompleto": "Daniel Esteban Maldonado Espitia"

    },
    {
        "matricula": "A00000002",
        "nombreCompleto": "Daniel Munive Meneses"

    },
    {
        "matricula": "A00000003",
        "nombreCompleto": "Daniel Flores Rodriguez"

    },
    {
        "matricula": "A00000004",
        "nombreCompleto": "Ezequiel Lozano Guerrero"

    },
    {
        "matricula": "A00000005",
        "nombreCompleto": "Fernando Jimenez"

    },
    {
        "matricula": "A00000006",
        "nombreCompleto": "Emiliano Zapata"

    },
    {
        "matricula": "A00000007",
        "nombreCompleto": "Leticia Rodríguez Aguilar"
    }
]

const AdministrarUsuariosDirectivos = ({userTypeUsuariosDirectivos}) => { /* En caso de ser asesorados se espera un tipo de usuario "asesorados", para mostrar unicamente el titulo de asesorados, cualquier otra palabra mostrara el titulo asesor y el boton de link para asesores */

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    return(
        <Template view = "administrar">


            {(userTypeUsuariosDirectivos === 'asesorados') ? 

            <h1> Administrar asesorados </h1>
            
            :

            <div className='btn_AdministrarUsuariosDirectivos'>

            <h1> Administrar asesores </h1>

            <div className='botonCopiarLinkRegistro'>
                <BotonConImagen 
                onClick={'Hola'} 
                backgroundColor='grisClaro'
                size="largo" 
                Image={FaCopy} >
                    <div className='textoDeBoton'>Generar Nuevo Link de Registro</div> 
                </BotonConImagen>
            </div>

            </div> 
            
            }
 
            <div className = 'divListaUsuarios'>
                <ListaUsuarios data = {dataUsuarios}></ListaUsuarios>
            </div>

            <div className = 'btnAtras'>
                <BotonSencillo
                    onClick = {() => routeChange("./administrar")}
                    backgroundColor = 'turquesa'
                    size = 'normal'
                >
                    Atrás
                </BotonSencillo>
            </div>
            
        </Template>
    )

};

export default AdministrarUsuariosDirectivos
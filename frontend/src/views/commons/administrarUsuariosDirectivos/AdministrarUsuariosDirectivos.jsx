import React,{useState}  from 'react'
import '../../../index.css'
import './AdministrarUsuariosDirectivos.css'
import { useNavigate } from "react-router-dom";
import { Template, ListaUsuarios, BotonSencillo, BotonConImagen } from '../../../routeIndex'

import { FaCopy} from 'react-icons/fa'

const dataUsuarios = [
    {
        "id": 1,
        "nombreCompleto": "Daniel Esteban Maldonado Espitia"

    },
    {
        "id": 2,
        "nombreCompleto": "Daniel Munive Meneses"

    },
    {
        "id": 3,
        "nombreCompleto": "Daniel Flores Rodriguez"

    },
    {
        "id": 4,
        "nombreCompleto": "Ezequiel Lozano Guerrero"

    },
    {
        "id": 5,
        "nombreCompleto": "Fernando Jimenez"

    },
    {
        "id": 6,
        "nombreCompleto": "Emiliano Zapata"

    },
    {
        "id": 5,
        "nombreCompleto": "Leticia Rodríguez Aguilar"

    }
]

const AdministrarUsuariosDirectivos = (userTypeUsuariosDirectivos) => {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [active, setActive] = useState(false);
  
    const toggle = () => {
        setActive(!active)
    }
    
    window.toggle = toggle;



    return(
        <>
        <Template view = "administrar">


        {(userTypeUsuariosDirectivos === 'Asesorados') ? 

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
                    onClick = {() => routeChange("./AdministrarUsuarios")}
                    backgroundColor = 'turquesa'
                    size = 'normal'
                >
                    Atrás
                </BotonSencillo>
            </div>
            
        </Template>
        </>
    )

};

export default AdministrarUsuariosDirectivos
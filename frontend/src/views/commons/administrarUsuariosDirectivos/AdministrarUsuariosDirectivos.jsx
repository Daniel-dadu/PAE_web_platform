import React, { useEffect, useState }  from 'react'
import '../../../index.css'
import './AdministrarUsuariosDirectivos.css'
import { useNavigate } from "react-router-dom";
import axios from 'axios';
import { Template, ListaUsuarios, BotonSencillo, BotonConImagen } from '../../../routeIndex'

import { FaCopy} from 'react-icons/fa'

// const dataUsuarios = [
//     {
//         "matricula": "A00000001",
//         "nombreCompleto": "Daniel Esteban Maldonado Espitia"

//     },
//     {
//         "matricula": "A00000002",
//         "nombreCompleto": "Daniel Munive Meneses"

//     },
//     {
//         "matricula": "A00000003",
//         "nombreCompleto": "Daniel Flores Rodriguez"

//     },
//     {
//         "matricula": "A00000004",
//         "nombreCompleto": "Ezequiel Lozano Guerrero"

//     },
//     {
//         "matricula": "A00000005",
//         "nombreCompleto": "Fernando Jimenez"

//     },
//     {
//         "matricula": "A00000006",
//         "nombreCompleto": "Emiliano Zapata"

//     },
//     {
//         "matricula": "A00000007",
//         "nombreCompleto": "Leticia Rodríguez Aguilar"
//     }
// ]

const AdministrarUsuariosDirectivos = ({userRol}) => { /* En caso de ser asesorados se espera un tipo de usuario "asesorados", para mostrar unicamente el titulo de asesorados, cualquier otra palabra mostrara el titulo asesor y el boton de link para asesores */

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [dataUsuarios, setDataUsuarios] = useState([])

    useEffect(() => {
        var config = {
            method: 'get',
            url: `http://20.225.209.57:3093/administracion/get_users_by_rol?rol=${userRol}`,
            headers: { }
        };
        
        axios(config)
        .then(response => {
            setDataUsuarios(response.data)
        })
        .catch(error => {
            const errorMessage = error.response.data
            alert(errorMessage ? errorMessage : "Error: no se pudo establecer conexión con la base de datos")
        })
    }, [setDataUsuarios, userRol])

    return(
        <Template view = "administrar">


            {(userRol === 'asesor') ? 

            <div className='btn_AdministrarUsuariosDirectivos'>

                <h1> Administrar asesores </h1>

                <div className='botonCopiarLinkRegistro'>
                    <BotonConImagen 
                    onClick={() => alert('Genera el link')} 
                    backgroundColor='grisClaro'
                    size="largo" 
                    Image={FaCopy} >
                        <span className='textoDeBoton'>Generar Nuevo Link de Registro</span> 
                    </BotonConImagen>
                </div>

            </div> 
            
            :

            <h1> Administrar {userRol === 'asesorado' ? "asesorados" : "directivos"} </h1>
            
            }
 
            <div className = 'divListaUsuarios'>
                <ListaUsuarios data = {dataUsuarios} />
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
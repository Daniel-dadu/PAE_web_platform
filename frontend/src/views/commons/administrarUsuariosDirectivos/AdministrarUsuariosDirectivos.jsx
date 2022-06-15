import React, { useEffect, useState }  from 'react'
import '../../../index.css'
import './AdministrarUsuariosDirectivos.css'
import { useNavigate } from "react-router-dom";
import axios from 'axios';
import { Template, ListaUsuarios, BotonSencillo, BotonConImagen } from '../../../routeIndex'

import {CopyToClipboard} from 'react-copy-to-clipboard'

import { FaCopy, FaUserPlus } from 'react-icons/fa'

const AdministrarUsuariosDirectivos = ({userRol}) => { /* En caso de ser asesorados se espera un tipo de usuario "asesorados", para mostrar unicamente el titulo de asesorados, cualquier otra palabra mostrara el titulo asesor y el boton de link para asesores */


    let navigate = useNavigate()

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

    const [copied, setCopied] = useState(false);

    return(
        <Template view = "administrar">


            {(userRol === 'asesor') ? 

            <div className='btn_AdministrarUsuariosDirectivos'>

                <h1> Administrar asesores </h1>

                <div className='botonCopiarLinkRegistro'>
                <CopyToClipboard text="http://20.225.209.57/registroAsesorDatos" onCopy={() => setCopied(true)}>
                    <BotonConImagen 
                    onClick={() => {navigator.clipboard.writeText('localhost')}} 
                    backgroundColor='grisClaro'
                    size="largo" 
                    Image={FaCopy} >
                        <span className='textoDeBoton'>
                            {
                                copied ? "Link copiado correctamente" : "Copiar Link de Registro de Asesores"
                            }
                        </span> 
                    </BotonConImagen>
                </CopyToClipboard> 
                </div>

            </div> 
            
            : userRol === 'directivo' ? 

            <div className='btn_AdministrarUsuariosDirectivos'>
                <h1> Administrar directivos </h1>
                <div className='botonCopiarLinkRegistro'>
                    <BotonConImagen 
                    onClick={() => navigate('/registrarDirectivo')} 
                    backgroundColor='grisClaro'
                    size="largo" 
                    Image={FaUserPlus} >
                        <span className='textoDeBoton'>Registrar un nuevo directivo</span> 
                    </BotonConImagen>
                </div>
            </div>

            :

            <h1> Administrar asesorados </h1>
            
            }
 
            <div className = 'divListaUsuarios'>
                <ListaUsuarios data = {dataUsuarios} rol={userRol} />
            </div>

            <div className = 'btnAtras'>
                <BotonSencillo
                    onClick = {() => navigate("/administrar")}
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
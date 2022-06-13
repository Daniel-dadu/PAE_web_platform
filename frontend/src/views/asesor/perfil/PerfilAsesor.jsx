import React, { useState, useEffect } from 'react'
import './PerfilAsesor.css'
import { BotonCambioPerfil, ListaUnidadesDeFormacionAsesor, Perfil } from '../../../routeIndex'
import axios from 'axios'

function PerfilAsesor(){

    const [UFsUser, setUFsUser] = useState([])

    useEffect(() => {
        const config = {
            method: 'get',
            url: `http://20.225.209.57:3092/perfil/get_user_ufs/?matricula=${localStorage.usuario}`,
            headers: { }
        };
        
        axios(config)
        .then(response => {
            setUFsUser(response.data)
        })
        .catch(error => {
            alert(error)
        })
          
    }, [setUFsUser])

    return(

        <Perfil>
            <div className = 'containerBtnCambioTipoUsuario'>
                <BotonCambioPerfil />
            </div>

            <div className = 'containerListaUFsAsesor'>
                <ListaUnidadesDeFormacionAsesor data = {UFsUser} />
            </div>
        </Perfil>
        
    )

}

export default PerfilAsesor
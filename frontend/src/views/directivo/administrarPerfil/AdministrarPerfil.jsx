import React, { useEffect, useState } from 'react'
import './AdministrarPerfil.css'

import { Template, InformacionPersonalUsuario, BotonSencillo, ListaUnidadesDeFormacionAsesor } from '../../../routeIndex'
import { useNavigate, useParams } from 'react-router-dom'
import axios from 'axios'


function AdministrarPerfil() {

    const navigate = useNavigate()

    const { rol, iduser } = useParams()

    const [UFsUser, setUFsUser] = useState([])

    useEffect(() => {
        if(rol === 'asesor') {
            const config = {
                method: 'get',
                url: `http://20.225.209.57:3092/perfil/get_user_ufs/?matricula=${iduser}`,
                headers: { }
            };
            
            axios(config)
            .then(response => {
                setUFsUser(response.data)
            })
            .catch(error => {
                alert(error)
            })
        }
          
    }, [rol, iduser, setUFsUser])


    return (
        <Template view='administrar'>

            <div className='btn_PerfilCommon'>

                <h1> Editar perfil de {rol} </h1>

            </div>

            <div className='boxPerfilCommon'>
                <InformacionPersonalUsuario idUserParam={iduser} rolUserParam={rol} />
            </div>

            {
                rol === 'asesor' &&
                <div className = 'containerListaUFsAsesorAdmin'>
                    <ListaUnidadesDeFormacionAsesor data = {UFsUser} />
                </div>
            }

            {/* <div className = {rol === 'asesor' ? 'btnAtrasAsesorPosition' : 'btnAtras'}> */}
            <div className = {'btnAtrasAsesorPosition ' + (rol !== 'asesor' && ' btnAtrasAsesoradoPosition')}>
                <BotonSencillo
                    onClick = {() => navigate(rol === 'asesor' ? "/administrarAsesores" : rol === 'asesorado' ? "/administrarAsesorados" : "/administrarDirectivos")}
                    backgroundColor = 'turquesa'
                    size = 'normal'
                >
                    Atrás
                </BotonSencillo>
            </div>

        </Template>
    )
}

export default AdministrarPerfil
import React, { useState, useEffect } from 'react'
import './RespuestasEncuestas.css'
import { useNavigate } from "react-router-dom";
import Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal.js'
import { Template, BotonSencillo, ListaDesplegable, PopUpEncuesta } from '../../../routeIndex'
import { FaSearch } from "react-icons/fa";

import axios from 'axios'

function RespuestasEncuestas({rolUser}){

    let navigate = useNavigate()

    const [originalUsersEncuestas, setOriginalUsersEncuestas] = useState([])
    const [usersEncuestas, setUsersEncuestas] = useState([])

    useEffect(() => {
        const config = {
            method: 'get',
            url: `http://20.225.209.57:3096/encuesta/get_encuestas_respondidas/?rol=${rolUser}`,
            headers: { }
        }
        
        axios(config)
        .then(response => {
            setOriginalUsersEncuestas(response.data)
            setUsersEncuestas(response.data)
        })
        .catch(error => {
            alert(error)
        })
          
    }, [rolUser, setOriginalUsersEncuestas, setUsersEncuestas])

    const [textoBusqueda, setTextoBusqueda] = useState('')

    useEffect(() => {
        setUsersEncuestas( 
            textoBusqueda === '' ? originalUsersEncuestas :
            originalUsersEncuestas.filter(usr => usr.matricula.startsWith(textoBusqueda) || usr.nombreUsuario.startsWith(textoBusqueda))
        )
    }, [textoBusqueda, originalUsersEncuestas, setUsersEncuestas])

    const [activoEncuesta, setActivoEncuesta] = useState(false)
    const cerrarEncuesta = () => setActivoEncuesta(!activoEncuesta)

    const [idAsesoriaState, setIdAsesoriaState] = useState(null)
    const [idEncuestadoState, setIdEncuestadoState] = useState(null)

    const selectEncuesta = (idAsesoria, idEncuestado) => {
        setIdAsesoriaState(idAsesoria)
        setIdEncuestadoState(idEncuestado)
        cerrarEncuesta()
    }

    return(
        <Template view = 'administrar'>

            <Modal active = {activoEncuesta} toggle = {cerrarEncuesta}>
                <PopUpEncuesta 
                    tipo={3} 
                    rolUser={rolUser}
                    idAsesoria={idAsesoriaState}
                    matriculaEncuestado={idEncuestadoState} 
                    activo={activoEncuesta} 
                    ocultarPopUp={cerrarEncuesta} 
                />
            </Modal>

            <h1> Respuestas de encuestas de { rolUser === 'asesor' ? "asesores" : "asesorados" } </h1>

            <div className = 'containerBarraBusqueda'>
                <input 
                    type = 'text' 
                    placeholder = {`Bucar Usuario`} 
                    onChange={({ target }) => setTextoBusqueda(target.value)}
                />
                <FaSearch className = 'icono'/>
            </div>

            <div className='users_encuestas_container'>
                {
                    Object.keys(usersEncuestas).map((index) => 
                        <div className = 'containerListaDesplegableAsesorias' key={index}>
                            <ListaDesplegable
                                fecha = {usersEncuestas[index]['matricula'] + " - " + usersEncuestas[index]['nombreUsuario']}
                                tipo = {2}
                                arrContenido = {usersEncuestas[index].respuestasEncuestas}
                                idEncuestado = {usersEncuestas[index]['matricula']}
                                onClickTipo2 = {selectEncuesta}
                            />
                        </div>
                    )
                }
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

}

export default RespuestasEncuestas
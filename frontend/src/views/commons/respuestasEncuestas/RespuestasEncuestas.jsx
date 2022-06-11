import React, { useState, useEffect } from 'react'
import './RespuestasEncuestas.css'
import { useNavigate } from "react-router-dom";
import Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal.js'
import { Template, BotonSencillo, ListaDesplegable, PopUpEncuesta } from '../../../routeIndex'
import { FaSearch } from "react-icons/fa";
import usuariosJSON from './PruebaRespuestasEncuestas.json' // JSON de prueba

function RespuestasEncuestas({rolUser}){

    let navigate = useNavigate()

    const [usersEncuestas, setUsersEncuestas] = useState(usuariosJSON)

    const [textoBusqueda, setTextoBusqueda] = useState('')

    useEffect(() => {
        setUsersEncuestas( 
            textoBusqueda === '' ? usuariosJSON :
            usuariosJSON.filter(usr => usr.matricula.startsWith(textoBusqueda) || usr.nombreUsuario.startsWith(textoBusqueda))
        )
    }, [textoBusqueda, setUsersEncuestas])

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
                    idAsesoria={idAsesoriaState} // Esto debe obtenerse del número de la asesoría al que corresponde
                    // matriculaEncuestado="A00000001" // Esto debe venir del usuario del que se busca la respuesta
                    matriculaEncuestado={idEncuestadoState} // Esto debe venir del usuario del que se busca la respuesta
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
                                arrContenido = {usersEncuestas[index]['asesorias']}
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
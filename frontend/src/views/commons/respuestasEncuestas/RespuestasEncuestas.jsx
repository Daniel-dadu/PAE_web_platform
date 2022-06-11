import React, {useState} from 'react'
import './RespuestasEncuestas.css'
import { useNavigate } from "react-router-dom";
import Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal.js'
import { Template, BotonSencillo, ListaDesplegable, PopUpEncuesta } from '../../../routeIndex'
import { FaSearch } from "react-icons/fa";
import usuariosJSON from './PruebaRespuestasEncuestas.json' // JSON de prueba

function RespuestasEncuestas({rolUser}){

    let navigate = useNavigate()

    const [activoEncuesta, setActivoEncuesta] = useState(false)
    const cerrarEncuesta = () => setActivoEncuesta(!activoEncuesta)

    return(
        <Template view = 'administrar'>

            <Modal active = {activoEncuesta} toggle = {cerrarEncuesta}>
                <PopUpEncuesta 
                    tipo={3} 
                    idAsesoria={92} // Esto debe obtenerse del número de la asesoría al que corresponde
                    // matriculaEncuestado="A00000001" // Esto debe venir del usuario del que se busca la respuesta
                    matriculaEncuestado="A01657967" // Esto debe venir del usuario del que se busca la respuesta
                    activo={activoEncuesta} 
                    ocultarPopUp={cerrarEncuesta} 
                />
            </Modal>

            <h1> Respuestas de encuestas de { rolUser === 'asesor' ? "asesores" : "asesorados" } </h1>

            <div className = 'containerBarraBusqueda'>
                <input type = 'text' placeholder = {`Bucar Usuario`} />
                <FaSearch className = 'icono'/>
            </div>

            <div className='users_encuestas_container'>
                {
                    Object.keys(usuariosJSON['usuarios']).map((index) => 
                        <div className = 'containerListaDesplegableAsesorias' key={index}>
                            <ListaDesplegable
                                fecha = {usuariosJSON['usuarios'][index]['nombreUsuario']}
                                tipo = {2}
                                arrContenido = {usuariosJSON['usuarios'][index]['asesorias']}
                                onClickTipo2 = {cerrarEncuesta}
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
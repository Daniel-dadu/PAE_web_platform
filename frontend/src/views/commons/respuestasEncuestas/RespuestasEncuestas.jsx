import React, {useState} from 'react'
import './RespuestasEncuestas.css'
import { useNavigate } from "react-router-dom";
import Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal.js'
import { Template, BotonSencillo, ListaDesplegable, PopUpEncuesta } from '../../../routeIndex'
import { FaSearch } from "react-icons/fa";
import usuariosJSON from './PruebaRespuestasEncuestas.json' // JSON de prueba


const data2 = [
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: 9

    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: 3
    },
    {
        tipoDePregunta:"abierta",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: "Mucho texto muy explicito."
    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿honestamente uya no se que preguntate asi que solo porndre mucho tennto?",
        respuesta: 6

    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿quieres una ultima pregunta o asi estas bien?",
        respuesta: 8

    }

]


function RespuestasEncuestas({rolUser}){

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [activoEncuesta, setActivoEncuesta] = useState(false);

    const cerrarEncuesta = () => setActivoEncuesta(!activoEncuesta);

    return(

        <div>

            <Template view = 'administrar'>

                <Modal active = {activoEncuesta} toggle = {cerrarEncuesta}>
                    <PopUpEncuesta 
                        tipo={3} 
                        nombreEvaluado="Daniel Maldonado" 
                        respuestasAsesor={ data2 } 
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
                        onClick = {() => routeChange("./administrar")}
                        backgroundColor = 'turquesa'
                        size = 'normal'
                    >
                        Atrás
                    </BotonSencillo>
                </div>

            </Template>

        </div>
        
    )

}

export default RespuestasEncuestas
/* eslint no-eval: 0 */

import React, {useState, useEffect} from 'react'
import '../../../index.css'
import './PanelNotificaciones.css'
import { Template, Notificacion, BotonConImagen, PupUpSolicitudAsesoria } from '../../../routeIndex'
import { FiMail } from 'react-icons/fi'
import { useNavigate } from "react-router-dom"
import axios from 'axios'

const PanelNotificaciones = () => { /* En caso de ser directivo se espera un tipo de usuario "directivo", para mostrar el boton de enviar notificacion, cualquier otra palabra para el panel de notificaciones de asesor y asesorado */

    const [activePopUp, setActivePopUp] = useState(false);
    const [asesoriaJSON, setAsesoriaJSON] = useState(
        {
            fecha:{
                "dia":0,
                "mes":0,
                "hora":0
            },
            asesorado:"",
            unidadFormacion: "",
            duda:"",
            imagenes:{
                img1:"",
                img2:"",
                img3:""
            },
            asesores: []
        }
    );
    
    const togglePopUp = (idUsuario, hora, dia, mes, anio) => {

        console.log(idUsuario)

        if(idUsuario !== undefined && hora !== undefined && dia !== undefined && mes !== undefined && anio !== undefined){

            var config = {
                method: 'get',
                url: `http://20.225.209.57:3031/calendario/get_informacionAsesoria/?idUsuario=${idUsuario}&hora=${hora}&dia=${dia}&mes=${mes}&anio=${anio}`,
                headers: {}
            };
            
            axios(config)
            .then(function (response) {
                // console.log(JSON.stringify(response.data));
                console.log(JSON.stringify(response.data))
                setAsesoriaJSON(
                    {
                        fecha:{
                            "dia":response.data['dia'],
                            "mes":response.data['mes'],
                            "hora":response.data['hora']
                        },
                        asesorado:idUsuario,
                        unidadFormacion: response.data['uF'],
                        duda:response.data['duda'],
                        imagenes:{
                            img1:response.data['images'][0],
                            img2:response.data['images'][1],
                            img3:response.data['images'][2]
                        },
                        asesores: []
                    }
                );
            })
            .catch(function (error) {
                console.log(error);
            });

        }
        else{
            setAsesoriaJSON(
                {
                "hora": 0,
                "dia": 0,
                "mes": 0,
                "anio": 0,
                "usuario": "",
                "duda": "",
                "images": []
                }
            );
        }

        setActivePopUp(!activePopUp)

    }

    const navigate = useNavigate();

    // Si se intenta ingresar a esta vista pero no se cuenta con el localStorage.usuario, se redirige a /landingPage
    useEffect(() => {
    if(!localStorage.usuario){
        localStorage.clear()
        navigate('/landingPage')
        return
    }
    }, [navigate])

    const [notificacionesJSON, setNotificacionesJSON] = useState({
        "notificaciones": []
    });

    // Hook para hacer la llamada a la API haciendo uso de la librería axios de JS
    useEffect(() => {
        
        var config = {
            method: 'get',
            url: `http://20.225.209.57:3030/notificacion/get_notificaciones/?idUsuario=${localStorage.usuario}`,
            headers: {}
        };
        
        axios(config)
        .then(function (response) {
            // console.log(JSON.stringify(response.data));
            setNotificacionesJSON(response.data);
            // console.log(JSON.stringify(notificacionesJSON))
        })
        .catch(function (error) {
            console.log(error);
        });

    }, [setNotificacionesJSON])

    return(
        <>
        <PupUpSolicitudAsesoria
            data = {asesoriaJSON}
            activo = {activePopUp}
            accion = {() => {togglePopUp("A94949494", 10, 1, 6, 2022)}}
        >
        </PupUpSolicitudAsesoria>
        <Template view = "notificaciones">
            
            {(localStorage.rolUsuario === 'directivo') ? 

                <div className='btn_NotificacionIrAEnviar'>

                    <h1> Notificaciones </h1>

                    <div className='botonEnviarNotiHola'>
                        <BotonConImagen 
                        onClick={() => navigate('/EnviarNotificacionDirectivos')} 
                        backgroundColor='blanco'
                        size="largo" 
                        Image={FiMail} >
                            Enviar notificación
                        </BotonConImagen>
                    </div>

                </div> 
                
                : <h1> Notificaciones </h1>
                
            }
            
            {
                Object.keys(notificacionesJSON['notificaciones']).reverse().map((index) => {
                    return(
                        <>
                        <div style = {
                            (localStorage.rolUsuario === 'directivo')
                                ? (notificacionesJSON['notificaciones'][index]['origen'] === "Asesoria reservada")
                                    ? {cursor: 'pointer'}
                                    : {cursor: 'auto'}
                                : {cursor: 'auto'}
                        }>
                            <Notificacion
                                onClick = {
                                    (localStorage.rolUsuario === 'directivo')
                                        ? (notificacionesJSON['notificaciones'][index]['origen'] === "Asesoria reservada")
                                            ? () => {setActivePopUp(!activePopUp)}
                                            : () => {}
                                        : () => {}
                                }
                                color = {
                                    (notificacionesJSON['notificaciones'][index]['origen'] === "Asesoria reservada")
                                        ? "azul"
                                        : (notificacionesJSON['notificaciones'][index]['origen'] === "Asesoria confirmada")
                                            ? "verde"
                                            : "rojo"
                                }
                                titulo = {notificacionesJSON['notificaciones'][index]['titulo']}
                                leyenda = {notificacionesJSON['notificaciones'][index]['leyenda'].substring(0,10) + ' - ' + notificacionesJSON['notificaciones'][index]['leyenda'].substring(11,16)}
                                contenido = {notificacionesJSON['notificaciones'][index]['contenido']}
                            >
                            </Notificacion>
                        </div>
                        <br/>
                        </>
                    )
                })
            }

        </Template>
        </>
    )

};

export default PanelNotificaciones
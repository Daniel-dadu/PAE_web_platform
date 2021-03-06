/* eslint no-eval: 0 */

import React, {useState, useEffect} from 'react'
import '../../../index.css'
import './PanelNotificaciones.css'
import { Template, Notificacion, BotonConImagen, PupUpSolicitudAsesoria, dateFunctions } from '../../../routeIndex'
import { FiMail } from 'react-icons/fi'
import { useNavigate } from "react-router-dom"
import axios from 'axios'

var informacionAsesoria = {
    "idAsesor": '',
    "nombreUF": '',
    "idAsesorado": '',
    "hora": 0,
    "dia": 0,
    "mes": 0,
    "anio": 0,
    "lugar": ''
}

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
    
    const togglePopUp = (idUsuario, nombreUsuario, hora, dia, mes, anio) => {

        if(idUsuario !== undefined && hora !== undefined && dia !== undefined && mes !== undefined && anio !== undefined){

            var config = {
                method: 'get',
                url: `http://20.225.209.57:3031/calendario/get_informacionAsesoria/?idUsuario=${idUsuario}&hora=${hora}&dia=${dia}&mes=${mes}&anio=${anio}`,
                headers: {}
            };
            
            axios(config)
            .then(function (response) {
                // console.log(JSON.stringify(response.data));
                // console.log(JSON.stringify(response.data))
                informacionAsesoria["idAsesorado"] = idUsuario;
                informacionAsesoria["nombreUF"] = response.data['uF'];
                informacionAsesoria["hora"] = response.data['hora'];
                informacionAsesoria["dia"] = response.data['dia'];
                informacionAsesoria["mes"] = response.data['mes'];
                informacionAsesoria["anio"] = response.data['anio'];
                // console.log(JSON.stringify(informacionAsesoria))

                var unidadFormacion = response.data['uF'];

                var config_2 = {
                    method: 'get',
                    url: `http://20.225.209.57:3030/notificacion/get_asesoresDisponibles/?hora=${hora}&dia=${dia}&mes=${mes}&anio=${anio}&nombreUF=${unidadFormacion}`,
                    headers: {}
                };
                
                axios(config_2)
                .then(function (response_2) {
                    // console.log(JSON.stringify(response.data));
                    // console.log(JSON.stringify(response_2.data['asesoresDisponibles']))
                    setAsesoriaJSON(
                        {
                            fecha:{
                                "dia":response.data['dia'],
                                "mes":dateFunctions.getMonthEspanol(response.data['mes']-1) + " del " + response.data['anio'],
                                "hora":response.data['hora'] + " hrs."
                            },
                            asesorado:nombreUsuario + ' - ' + idUsuario,
                            unidadFormacion: response.data['uF'],
                            duda:response.data['duda'],
                            imagenes:{
                                img1:response.data['images'][0],
                                img2:response.data['images'][1],
                                img3:response.data['images'][2]
                            },
                            asesores: response_2.data['asesoresDisponibles']
                        }
                    );
                })
                .catch(function (error_2) {
                    console.log(error_2);
                });

            })
            .catch(function (error) {
                console.log(error);
            });

        }
        else{
            setAsesoriaJSON(
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

            informacionAsesoria = {
                "idAsesor": '',
                "nombreUF": '',
                "idAsesorado": '',
                "hora": 0,
                "dia": 0,
                "mes": 0,
                "anio": 0,
                "lugar": ''
            }

            // console.log(JSON.stringify(informacionAsesoria))

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

    // Hook para hacer la llamada a la API haciendo uso de la librer??a axios de JS
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

    const aceptarAsesoria = (idAsesor, lugarAsesoria) => {

        informacionAsesoria["idAsesor"] = idAsesor;
        informacionAsesoria["lugar"] = lugarAsesoria;
        // console.log(JSON.stringify(informacionAsesoria))

        const config = {
            method: 'post',
            url: 'http://20.225.209.57:3030/notificacion/aceptarAsesoria',
            headers: { 
                'Content-Type': 'application/json'
            },
            data: JSON.stringify({
                "idAsesor": informacionAsesoria["idAsesor"],
                "nombreUF": informacionAsesoria["nombreUF"],
                "idAsesorado": informacionAsesoria["idAsesorado"],
                "hora": informacionAsesoria["hora"],
                "dia": informacionAsesoria["dia"],
                "mes": informacionAsesoria["mes"],
                "anio": informacionAsesoria["anio"],
                "lugar": informacionAsesoria["lugar"]
            })
        }
        
        axios(config)
        .then(response => {
            
            alert("Bien, " + response.data)

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
                setActivePopUp(!activePopUp)

                informacionAsesoria = {
                    "idAsesor": '',
                    "nombreUF": '',
                    "idAsesorado": '',
                    "hora": 0,
                    "dia": 0,
                    "mes": 0,
                    "anio": 0,
                    "lugar": ''
                }

                // console.log(JSON.stringify(informacionAsesoria))

            })
            .catch(function (error) {
                console.log(error);
            });

        })
        .catch(error => {
            alert("Error: " + error.response.data)
        });
    }

    const cancelarAsesoria = () => {

        const config = {
            method: 'post',
            url: 'http://20.225.209.57:3030/notificacion/cancelarAsesoria',
            headers: { 
                'Content-Type': 'application/json'
            },
            data: JSON.stringify({
                "nombreUF": informacionAsesoria["nombreUF"],
                "idAsesorado": informacionAsesoria["idAsesorado"],
                "hora": informacionAsesoria["hora"],
                "dia": informacionAsesoria["dia"],
                "mes": informacionAsesoria["mes"],
                "anio": informacionAsesoria["anio"]
            })
        }
        
        axios(config)
        .then(response => {
            
            alert("Bien, " + response.data)

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
                setActivePopUp(!activePopUp)

                informacionAsesoria = {
                    "idAsesor": '',
                    "nombreUF": '',
                    "idAsesorado": '',
                    "hora": 0,
                    "dia": 0,
                    "mes": 0,
                    "anio": 0,
                    "lugar": ''
                }

                // console.log(JSON.stringify(informacionAsesoria))

            })
            .catch(function (error) {
                console.log(error);
            });

        })
        .catch(error => {
            alert("Error: " + error.response.data)
        });
    }

    return(
        <>
        <PupUpSolicitudAsesoria
            data = {asesoriaJSON}
            activo = {activePopUp}
            accion = {togglePopUp}
            accionCancelar = {() => {cancelarAsesoria()}}
            accionConfirmar = {aceptarAsesoria}
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
                            Enviar notificaci??n
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
                                            ? () => {togglePopUp((notificacionesJSON['notificaciones'][index]['contenido'].substring(notificacionesJSON['notificaciones'][index]['contenido'].length-37,notificacionesJSON['notificaciones'][index]['contenido'].length-28)), (notificacionesJSON['notificaciones'][index]['contenido'].substring(9, notificacionesJSON['notificaciones'][index]['contenido'].length-52)), notificacionesJSON['notificaciones'][index]['leyenda'].substring(11,13), notificacionesJSON['notificaciones'][index]['leyenda'].substring(8,10), notificacionesJSON['notificaciones'][index]['leyenda'].substring(5,7), notificacionesJSON['notificaciones'][index]['leyenda'].substring(0,4))}
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
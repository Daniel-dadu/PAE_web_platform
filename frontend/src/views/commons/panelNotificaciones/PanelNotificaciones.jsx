/* eslint no-eval: 0 */

import React, {useState, useEffect} from 'react'
import '../../../index.css'
import './PanelNotificaciones.css'
import { Template, Notificacion, BotonConImagen, PupUpSolicitudAsesoria} from '../../../routeIndex'
import { FiMail } from 'react-icons/fi'
import { useNavigate } from "react-router-dom"
import axios from 'axios'

const info = {
    fecha:{
        "dia":9,
        "mes":"marzo",
        "hora":"3:00 PM"
    },
    asesorado:"Ezequiel Lozano",
    unidadFormacion: "Fundamentos químicos",
    duda:"Aquí debe ir mucho texto que describa la duda que tiene el alumno y debe estar escrita de la forma más específica posible.",
    imagenes:{
        img1:"https://bobbyhadz.com/images/blog/react-image-link/banner.webp",
        img2:"https://i.redd.it/rt5xnrhm93s51.jpg",
        img3:"https://www.ionos.mx/digitalguide/fileadmin/DigitalGuide/Screenshots_2020/screenshot-windows-10-1.png"
    }, 
    asesores: [
        {
            nombre: "Fernando Alonso"
        },
        {
            nombre: "Casimiro Buenavista"
        },
        {
            nombre:"Daniel Rodriguez"
        },
        {
            nombre:"Rafael Gonzales"
        }
    ]
}

const PanelNotificaciones = () => { /* En caso de ser directivo se espera un tipo de usuario "directivo", para mostrar el boton de enviar notificacion, cualquier otra palabra para el panel de notificaciones de asesor y asesorado */

    const [activePopUp, setActivePopUp] = useState(false);
    const [asesoriaJSON, setAsesoriaJSON] = useState(
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
    
    const togglePopUp = (idUsuario, hora, dia, mes, anio) => {

        if(hora !== undefined && dia !== undefined && mes !== undefined && anio !== undefined){

        var config = {
            method: 'get',
            url: `http://20.225.209.57:3031/calendario/get_informacionAsesoria/?idUsuario=${localStorage.usuario}&hora=${hora}&dia=${dia}&mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}`,
            headers: {}
        };
        
        axios(config)
        .then(function (response) {
            // console.log(JSON.stringify(response.data));
            // console.log(JSON.stringify(response.data))
            setAsesoriaJSON(response.data);
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
            data = {info}
            activo = {activePopUp}
            accion = {() => {setActivePopUp(!activePopUp)}}
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
import React, { useState } from 'react'
import './BarraLateral.css'

import { BiCalendar, BiEdit } from 'react-icons/bi'
import { MdNotificationsNone, MdLightMode, MdNightlight, MdOutlineSettings } from 'react-icons/md'
import { BsPeople } from 'react-icons/bs'
import pae_logo from '../../../assets/pae_logo.png'
import noUserImg from '../../../assets/noUserImg.png'
import mexico_flag_icon from '../../../assets/mexico_flag_icon.png'
import usa_flag_icon from '../../../assets/usa_flag_icon.png'

let btnInfo = {
    "asesor": {
        "buttons": [
            {
                "image": "imageUser",
                "text": "Perfil"
            },
            {
                "image": 1,
                "text": "Calendario"
            },
            {
                "image": 2,
                "text": "Notificaciones"
            }
        ],
        "backgroundColor": "#A1E01D",
        "selectedButtonColor": "#1B5821"
    },
    "asesorado": {
        "buttons": [
            {
                "image": "imageUser",
                "text": "Perfil"
            },
            {
                "image": 1,
                "text": "Calendario"
            },
            {
                "image": 3,
                "text": "Agendar asesoría"
            },
            {
                "image": 2,
                "text": "Notificaciones"
            }
        ],
        "backgroundColor": "#50C7F1",
        "selectedButtonColor": "#1B4858"
    },
    "directivo": {
        "buttons": [
            {
                "image": "imageUser",
                "text": "Perfil"
            },
            {
                "image": 1,
                "text": "Calendario"
            },
            {
                "image": 2,
                "text": "Notificaciones"
            },
            {
                "image": 4,
                "text": "Administrar"
            }
        ],
        "backgroundColor": "#4BE2BE",
        "selectedButtonColor": "#1B5558"
    }
}

// Descripción de las propiedades
/*
viewProp: Solo se recibe un string que indique el tipo de pantalla en el que se encuentra el usuario
Tipos de viewProp:
"perfil"
"calendario"
"notificaciones"
"agendarAsesoria"
"administrar"

Ejemplo de uso:
<BarraLateral viewProp="calendario" />
*/

function BarraLateral({viewProp}) {

    // IMPORTANTE: 
    // EL USO DEL LOCALSTORAGE ESTÁ MAL, ya que se pusieron opciones por si no se cuentan con las credenciales del usuario. Cambiar eso al final

    let barIconSize = 80

    const [settingsFlag, setSettingsFlag] = useState(false);

    const handleConfigButton = () => {
        console.log("holaa");
        setSettingsFlag(!settingsFlag);
    }



  return (
    <div className='barra_lateral-container'>
        
        {/* DISPLAY IDIOMA Y TEMA */}

        <div className='display-ajustes'>
            <div className='contenedor'>

            </div>
        </div>

        <div className='pae_logo-container'>
            <a href="/landingPage">
                <img src={pae_logo} alt="Logo PAE" />
            </a>
        </div>

        {/* MODIFICAR CONDICIONAL TERNARIO */}
            <div className='barra-container' 
                style={{backgroundColor: btnInfo[localStorage.rolUsuario ? localStorage.rolUsuario : 'asesorado'].backgroundColor}}
            >
                {
                    btnInfo[localStorage.rolUsuario ? localStorage.rolUsuario : 'asesorado'].buttons.map((btn, index) => {
                        let isImageString = typeof btn.image === "string"
                        let heightBtn = 0;


                        if(window.innerWidth < 720){
                            heightBtn ='100%'
                            barIconSize = 40
                        } else {
                            heightBtn = (localStorage.rolUsuario === "asesor") ? '33%' : '25%'
                        }


                        if(isImageString){
                            let perfilSelected = viewProp === "perfil"
                            return <div className={'barra_button' + (perfilSelected ? ' barra_button-selected' : '') } style={{height: heightBtn}} key={index}>
                                <a href={ localStorage.rolUsuario === "asesor" ? "/perfilAsesor" : localStorage.rolUsuario === "asesorado" ? "/perfilAsesorado" : "/perfilDirectivo" }>
                                    <img src={localStorage.fotoUsuario !== "null" ? localStorage.fotoUsuario : noUserImg} alt="Perfil" className={'profile-img' + (perfilSelected ? ' selected_icon' : '')} />
                                    <p className={'btn-text' + (perfilSelected ? ' selected_icon' : '')}>{btn.text}</p>
                                </a>
                                </div>
                        } else if(btn.image === 1) {
                            let calendarioSelected = viewProp === "calendario"
                            return <div className={'barra_button' + (calendarioSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}} key={index}>
                                    <a href="/calendario">
                                        <BiCalendar className={'icon_bar' + (calendarioSelected ? ' selected_icon' : '')} size={barIconSize}/>
                                        <p className={'btn-text' + (calendarioSelected ? ' selected_icon' : '')}>{btn.text}</p>
                                    </a>
                                </div>
                        } else if(btn.image === 2){
                            let notificacionesSelected = viewProp === "notificaciones"
                            return <div className={'barra_button' + (notificacionesSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}} key={ index } >
                                    <a href="/notificaciones">
                                        <MdNotificationsNone className={'icon_bar' + (notificacionesSelected ? ' selected_icon' : '')} size={barIconSize}/>
                                        <p className={'btn-text' + (notificacionesSelected ? ' selected_icon' : '')}>{btn.text}</p>
                                    </a>
                                </div>
                        } else if(btn.image === 3){
                            let agendarSelected = viewProp === "agendarAsesoria"
                            return <div className={'barra_button' + (agendarSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}} key={ index }>
                                    <a href="/agendarAsesoriaUF/ok">
                                        <BsPeople className={'icon_bar' + (agendarSelected ? ' selected_icon' : '')} size={barIconSize}/> 
                                        <p className={'btn-text' + (agendarSelected ? ' selected_icon' : '')}>{btn.text}</p>
                                    </a>
                                </div>
                        } else {
                            let administrarSelected = viewProp === "administrar"
                            return <div className={'barra_button' + (administrarSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}} key={ index }>
                                    <a href="/administrar">
                                        <BiEdit className={'icon_bar' + (administrarSelected ? ' selected_icon' : '')} size={barIconSize}/>
                                        <p className={'btn-text' + (administrarSelected ? ' selected_icon' : '')}>{btn.text}</p>
                                    </a>
                                </div>
                            
                        }
                    })
                    
                }

                {
               
                (
                    <div className={'barra_button_ajustes  '}  style={{height: "40"}}>
                        <button href='' onClick={ handleConfigButton } style={{cursor: 'pointer', backgroundColor: 'transparent'}}>
                            <MdOutlineSettings className={'icon_bar'} size={barIconSize}/>
                        </button>
                    </div>
                )
                }
            </div>

        <div className='footer-container'>
            <a href={"/" + viewProp}>
                {(localStorage.modo === "claro") ? <MdNightlight className='theme-icon' size={50} /> : <MdLightMode className='theme-icon' size={50} />}
            </a>
            <a href={"/" + viewProp}>
                {(localStorage.idioma === "espanol") ? <img src={usa_flag_icon} alt="" /> : <img src={mexico_flag_icon} alt="" />}
            </a>
        </div>

        <div className={`footer-container-general-responsive ${ !settingsFlag? "":"show-setting" }` } onClick={ handleConfigButton } >
            <div className='footer-container-responsive'>
                <a href={"/" + viewProp}>
                    {(localStorage.modo === "claro") ? <MdNightlight className='theme-icon' size={50} /> : <MdLightMode className='theme-icon' size={50} />}
                </a>
                <a href={"/" + viewProp}>
                    {(localStorage.idioma === "espanol") ? <img src={usa_flag_icon} alt="" /> : <img src={mexico_flag_icon} alt="" />}
                </a>
            </div>  
        </div>

    </div>
  )
}

export default BarraLateral
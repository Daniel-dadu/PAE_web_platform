import React from 'react'
import './BarraLateral.css'

import { BiCalendar, BiEdit } from 'react-icons/bi'
import { MdNotificationsNone, MdLightMode, MdNightlight } from 'react-icons/md'
import { BsPeople } from 'react-icons/bs'
import pae_logo from '../../../assets/pae_logo.png'
import mexico_flag_icon from '../../../assets/mexico_flag_icon.png'
import usa_flag_icon from '../../../assets/usa_flag_icon.png'

import API from './API.json'

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

    // IMPORTANTE: Usar estos strings no es muy eficiente para el componente final, evaluar si se cambia por números 

    const barIconSize = 80

  return (
    <div className='barra_lateral-container'>
        <div className='pae_logo-container'>
            <a href="/">
                <img src={pae_logo} alt="Logo PAE" />
            </a>
        </div>

        <div className='barra-container' style={{backgroundColor: btnInfo[API.rolUser].backgroundColor }}>
            {
            btnInfo[API.rolUser].buttons.map((btn) => {
                let isImageString = typeof btn.image === "string"
                let heightBtn = (API.rolUser === "asesor") ? '33%' : '25%'

                if(isImageString){
                    let perfilSelected = viewProp === "perfil"
                    return <div className={'barra_button' + (perfilSelected ? ' barra_button-selected' : '') } style={{height: heightBtn}}>
                        <a href={ btn.user === "asesor" ? "/perfilAsesor" : API.rolUser === "asesorado" ? "/perfilAsesorado" : "/perfilDirectivo" }>
                        <img src={API.imageUser} alt="Perfil" className={'profile-img' + (perfilSelected ? ' selected_icon' : '')} />
                        <p className={'btn-text' + (perfilSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                } else if(btn.image === 1) {
                    let calendarioSelected = viewProp === "calendario"
                    return <div className={'barra_button' + (calendarioSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                        <a href="/calendario">
                        <BiCalendar className={'icon_bar' + (calendarioSelected ? ' selected_icon' : '')} size={barIconSize}/>
                        <p className={'btn-text' + (calendarioSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                } else if(btn.image === 2){
                    let notificacionesSelected = viewProp === "notificaciones"
                    return <div className={'barra_button' + (notificacionesSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                        <a href="/notificaciones">
                        <MdNotificationsNone className={'icon_bar' + (notificacionesSelected ? ' selected_icon' : '')} size={barIconSize}/>
                        <p className={'btn-text' + (notificacionesSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                } else if(btn.image === 3){
                    let agendarSelected = viewProp === "agendarAsesoria"
                    return <div className={'barra_button' + (agendarSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                        <a href="/agendarAsesoriaUF/ok">
                        <BsPeople className={'icon_bar' + (agendarSelected ? ' selected_icon' : '')} size={barIconSize}/> 
                        <p className={'btn-text' + (agendarSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                } else {
                    let administrarSelected = viewProp === "administrar"
                    return <div className={'barra_button' + (administrarSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                        <a href="/administrar">
                        <BiEdit className={'icon_bar' + (administrarSelected ? ' selected_icon' : '')} size={barIconSize}/>
                        <p className={'btn-text' + (administrarSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                }
            }
            )
            }
        </div>

        <div className='footer-container'>
            <a href={"/" + viewProp}>
                {(API.temaUser === "claro") ? <MdNightlight className='theme-icon' size={50} /> : <MdLightMode className='theme-icon' size={50} />}
            </a>
            <a href={"/" + viewProp}>
                {(API.idiomaUser === "espanol") ? <img src={usa_flag_icon} alt="" /> : <img src={mexico_flag_icon} alt="" />}
            </a>
        </div>

    </div>
  )
}

export default BarraLateral
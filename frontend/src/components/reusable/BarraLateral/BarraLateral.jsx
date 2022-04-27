import { React, useState } from 'react'
import './BarraLateral.css'

import { BiCalendar, BiEdit } from 'react-icons/bi'
import { MdNotificationsNone, MdLightMode, MdNightlight } from 'react-icons/md'
import { BsPeople } from 'react-icons/bs'
import pae_logo from '../../../assets/pae_logo.png'
import mexico_flag_icon from '../../../assets/mexico_flag_icon.png'
import usa_flag_icon from '../../../assets/usa_flag_icon.png'

import btnInfo from './btnInfo'

const routeBtn = (image, user) => {
    return typeof image === "string" ? 
    (user === "asesor" ? "/perfilAsesor" : user === "asesorado" ? "/perfilAsesorado" : "/perfilDirectivo") 
    : image === 1 ? "/calendario" : image === 3 ? "/agendarAsesoria" : "/"
}

function BarraLateral() {

    // IMPORTANTE: Usar estos strings no es muy eficiente para el componente final, evaluar si se cambia por números 
    let userProp = "directivo"
    let tema = "claro"
    let idioma = "espanol"
    let viewProp = "notificaciones" // Vista actual en la que se muestra la barra
    /*
    "perfil"
    "calendario"
    "notificaciones"
    "agendarAsesoria"
    "administrar"
    */

    const barIconSize = 80

  return (
    <div className='barra_lateral-container'>
        <div className='pae_logo-container'>
            <a href="/">
                <img src={pae_logo} alt="Logo PAE" />
            </a>
        </div>

        <div className='barra-container' style={{backgroundColor: btnInfo[userProp].backgroundColor }}>
            {
            btnInfo[userProp].buttons.map((btn) => {
                let isImageString = typeof btn.image === "string"
                let heightBtn = (userProp === "asesor") ? '33%' : '25%'

                if(isImageString){
                    let perfilSelected = viewProp === "perfil"
                    return (
                    <div className={'barra_button' + (perfilSelected ? ' barra_button-selected' : '') } style={{height: heightBtn}}>
                    <a href={ btn.user === "asesor" ? "/perfilAsesor" : userProp === "asesorado" ? "/perfilAsesorado" : "/perfilDirectivo" }>
                    <img src={btn.image} alt="Perfil" className={'profile-img' + (perfilSelected ? ' selected_icon' : '')} />
                    <p className={'btn-text' + (perfilSelected ? ' selected_icon' : '')}>{btn.text}</p>
                    </a>
                    </div>
                    )
                } else if(btn.image === 1) {
                    let calendarioSelected = viewProp === "calendario"
                    return (
                    <div className={'barra_button' + (calendarioSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                    <a href="/calendario">
                    <BiCalendar className={'icon_bar' + (calendarioSelected ? ' selected_icon' : '')} size={barIconSize}/>
                    <p className={'btn-text' + (calendarioSelected ? ' selected_icon' : '')}>{btn.text}</p>
                    </a>
                    </div>
                    )
                } else if(btn.image === 2){
                    let notificacionesSelected = viewProp === "notificaciones"
                    return <div className={'barra_button' + (notificacionesSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                        <a href="/notificaciones">
                        <MdNotificationsNone className={'icon_bar' + (notificacionesSelected ? ' selected_icon' : '')} size={barIconSize}/>
                        <p className={'btn-text' + (notificacionesSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                } else if(btn.image === 3){
                    let agendarSelected = viewProp == "agendarAsesoria"
                    return <div className={'barra_button' + (agendarSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                        <a href="/agendarAsesoria">
                        <BsPeople className={'icon_bar' + (agendarSelected ? ' selected_icon' : '')} size={barIconSize}/> 
                        <p className={'btn-text' + (agendarSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                } else {
                    let administrarSelected = viewProp == "administrar"
                    return <div className={'barra_button' + (administrarSelected ? ' barra_button-selected' : '')} style={{height: heightBtn}}>
                        <a href="/administrar">
                        <BiEdit className={'icon_bar' + (administrarSelected ? ' selected_icon' : '')} size={barIconSize}/>
                        <p className={'btn-text' + (administrarSelected ? ' selected_icon' : '')}>{btn.text}</p>
                        </a>
                        </div>
                }
                /*
                return <div className='barra_button' style={{height: heightBtn}}>
                <a href={ routeBtn(btn.image, userProp) }>
                {
                (isImageString) ? <img src={btn.image} alt="" />
                : (btn.image === 1) ? <BiCalendar className='icon_bar selected_icon' size={barIconSize}/>
                : (btn.image === 2) ? <MdNotificationsNone className='icon_bar' size={barIconSize}/>
                : (btn.image === 3) ? <BsPeople className='icon_bar' size={barIconSize}/> 
                : <BiEdit className='icon_bar' size={barIconSize}/>
                }
                <p className='btn-text selected_icon'>{btn.text}</p>
                </a>
                </div>
                */
            }
            )
            }
        </div>

        <div className='footer-container'>
            <a href="">
                {(tema === "claro") ? <MdNightlight className='theme-icon' size={50} /> : <MdLightMode className='theme-icon' size={50} />}
            </a>
            <a href="">
                {(idioma === "espanol") ? <img src={usa_flag_icon} alt="" /> : <img src={mexico_flag_icon} alt="" />}
            </a>
        </div>

    </div>
  )
}

export default BarraLateral
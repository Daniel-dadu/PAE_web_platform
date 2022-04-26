import React from 'react'
import './BarraLateral.css'

import { BiCalendar, BiEdit } from 'react-icons/bi'
import { MdNotificationsNone, MdLightMode, MdNightlight } from 'react-icons/md'
import { BsPeople } from 'react-icons/bs'
import pae_logo from '../../../assets/pae_logo.png'
import mexico_flag_icon from '../../../assets/mexico_flag_icon.png'
import usa_flag_icon from '../../../assets/usa_flag_icon.png'

import btnInfo from './btnInfo'

function BarraLateral() {

    // IMPORTANTE: Usar estos strings no es muy eficiente para el componente final, evaluar si se cambia por números 
    let user = "asesorado"
    let tema = "claro"
    let idioma = "espanol"
    const barIconSize = 80

  return (
    <div className='barra_lateral-container'>
        <div className='pae_logo-container'>
            <a href="">
                <img src={pae_logo} alt="Logo PAE" />
            </a>
        </div>

        <div className='barra-container' style={{backgroundColor: btnInfo[user].backgroundColor }}>
            {
            btnInfo[user].buttons.map((btn) => 
                <div className='barra_button' style={{height: (user == "asesor") ? '33%' : '25%'}}>
                <a href="">
                {
                (typeof btn.image === "string") ? <img src={btn.image} alt="" />
                : (btn.image === 1) ? <BiCalendar className='icon' size={barIconSize}/>
                : (btn.image === 2) ? <MdNotificationsNone className='icon' size={barIconSize}/>
                : (btn.image === 3) ? <BsPeople className='icon' size={barIconSize}/> 
                : <BiEdit className='icon' size={barIconSize}/>
                }
                <p>{btn.text}</p>
                </a>
                </div>
            )
            }
        </div>

        <div className='footer-container'>
            <a href="">
                {(tema == "claro") ? <MdNightlight className='theme-icon' size={50} /> : <MdLightMode className='theme-icon' size={50} />}
            </a>
            <a href="">
                {(idioma == "espanol") ? <img src={usa_flag_icon} alt="" /> : <img src={mexico_flag_icon} alt="" />}
            </a>
        </div>

    </div>
  )
}

export default BarraLateral
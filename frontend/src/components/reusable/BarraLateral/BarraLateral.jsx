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
    let user = "asesor"
    let tema = "claro"
    let idioma = "espanol"

  return (
    <div className='barra_lateral-container'>
        <div className='pae_logo-container'>
            <a href="">
                <img src={pae_logo} alt="Logo PAE" />
            </a>
        </div>

        <div className='barra-container'>
            {
            btnInfo[user].buttons.map((btn) => 
                <div className='barra_button'>
                <a href="">
                {
                (typeof btn.image === "string") ? <img src={btn.image} alt="" />
                : (btn.image === 1) ? <BiCalendar className='icon' size={100}/>
                : (btn.image === 2) ? <MdNotificationsNone className='icon' size={100}/>
                : (btn.image === 3) ? <BsPeople className='icon' size={100}/> 
                : <BiEdit className='icon' size={100}/>
                }
                <p>{btn.text}</p>
                </a>
                </div>
            )
            }
        </div>

        <div className='footer-container'>
            <a href="">
                {(tema == "claro") ? <MdNightlight /> : <MdLightMode />}
            </a>
            <a href="">
                {(idioma == "espanol") ? <img src={usa_flag_icon} alt="" /> : <img src={mexico_flag_icon} alt="" />}
            </a>
        </div>

    </div>
  )
}

export default BarraLateral
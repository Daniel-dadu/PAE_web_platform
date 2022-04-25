import React from 'react'
import { Nav, NavLink, Bars, NavMenu, NavBtnLink } from './NavbarElements';

export const LandingPage = () => {
  return (
    <>
       <Nav>
           <NavLink to="/">
                <h1>Logo</h1>
           </NavLink>
           <Bars/>
           <NavMenu>
               <NavLink to="/quienesSomos">
                   ¿Quiénes Somos?
               </NavLink>
               <NavLink to="/funcionamiento">
                   Funcionamiento
               </NavLink>
               <NavLink to="/Objetivos">
                   Objetivos
               </NavLink>
               <NavLink to="/equipoTrabajo">
                   Equipo de trabajo
               </NavLink>
           </NavMenu>
           
       </Nav>
    </>
  )
}

export default LandingPage;

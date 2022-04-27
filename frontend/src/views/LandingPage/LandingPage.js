import React from 'react'
import { Nav, NavLink, Bars, NavMenu } from './NavbarElements';
import './landingPage.css';

export const LandingPage = () => {
  return (
    <>
       <Nav>
           <NavLink to="/">
                <img className='logo-pae' src={ require('../../assets/PAE-logo.png') } alt='PAE'  />
           </NavLink>
           <Bars/>
           <NavMenu>

                <a href='#quienesSomos'>
                    ¿Quiénes Somos?
                </a>
                <a href='#funcionamiento'>
                    Funcionamiento
                </a>
                <a href='#objetivos'>
                    Objetivos
                </a>
                <a href='#equipo-trabajo'>
                    Equipo de trabajo
                </a>
                
{/* 
               <NavLink to="#quienesSomos" activeStyle>
                   ¿Quiénes Somos?
               </NavLink>
               <NavLink to="#funcionamiento" activeStyle>
                   Funcionamiento
               </NavLink>
               <NavLink to="#objetivos" activeStyle>
                   Objetivos
               </NavLink>
               <NavLink to="#equipo-trabajo" activeStyle>
                   Equipo de trabajo
               </NavLink> */}
           </NavMenu>
           
       </Nav>

       <section className='quienes-somos' id='quienesSomos'>

            <div className='izq'>
               <h1>¿Qué es el Programa de Asesor Estudiante?</h1>
               <div className='texto-derecha'>
                    <b>Asesorias</b>
                    <p>
                        Alumnos solidarios que
                        brindan asesorías a sus
                        compañeros.                        
                    </p>
                    <b> Servicio Social </b>
                    <p>
                        Clases de inglés a niños de
                        primaria de escasos
                        recursos.
                    </p>
               </div>
               <div className='btn-contenedor'>
                    <button> Saber más </button>
               </div>
            </div>


            <div className='der'>
                <img className='img-quienes-somos' src={ require('../../assets/estudiando-img.png') } />
            </div>


       </section>

       <section className='funcionamiento' id='funcionamiento'>
        
            


            <div className='izq'>
                <svg className='blob-funcionamiento' viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
                    <path className='blob-funcionamiento' fill="#455A64" d="M57.1,-57.2C70,-44.1,73.9,-22.1,72.8,-1.1C71.7,19.8,65.6,39.6,52.6,54.9C39.6,70.2,19.8,81,-1.5,82.5C-22.9,84.1,-45.8,76.4,-56.3,61.1C-66.8,45.8,-64.8,22.9,-64.1,0.8C-63.3,-21.4,-63.7,-42.7,-53.2,-55.9C-42.7,-69,-21.4,-73.9,0.3,-74.2C22.1,-74.6,44.1,-70.4,57.1,-57.2Z" transform="translate(100 100)" />
                </svg>
               <h1> Funcionamiento del Programa </h1>
               <p>
               El programa de asesor estudiante funciona de manera sencilla y rápida, trayendo como beneficios, entre otros, la oportunidad de conocer nuevas personas y mejoar calificaciones. 
               </p>

            </div>
            
            <div className='der'>
                <img className='img-quienes-somos' src={ require('../../assets/estudiando2-img.png') } />
            </div>
       </section>

       <section className='pasos-inscripcion'>
               


       </section>

       <section className='objetivos' id='objetivos'>
            objetivos
       </section>

       <section className='equipo-trabajo' id='equipo-trabajo'>
            Equipo de trabajo
       </section>
    </>
  )
}

export default LandingPage;
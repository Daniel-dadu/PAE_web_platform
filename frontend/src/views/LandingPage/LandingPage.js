import React, { useState } from 'react'
import { Nav, NavLink, Bars, NavMenu } from './NavbarElements';
import './landingPage.css';
import { FaPen, FaBookmark, FaAddressBook, FaHandsHelping, FaChevronDown } from 'react-icons/fa';



export const LandingPage = () => {

    const [ clicked, setClicked ] = useState(false);
    
    const handleClick = () => {
        setClicked(!clicked);
    }
  return (
    <>
       
       <Nav>
           <NavLink to="/">
                <img className='logo-pae' src={ require('../../assets/PAE-logo.png') } alt='PAE'  />
           </NavLink>
           <Bars onClick={ handleClick } />

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
                
           </NavMenu> 
           <div className={`navbar-responsive${clicked? ' active2':''} `} id='navbar-responsive'>
                <a href='#quienesSomos' onClick={ handleClick }>
                    ¿Quiénes Somos?
                </a>
                <a href='#funcionamiento' onClick={ handleClick }>
                    Funcionamiento
                </a>
                <a href='#objetivos' onClick={ handleClick }>
                    Objetivos
                </a>
                <a href='#equipo-trabajo' onClick={ handleClick }>
                    Equipo de trabajo
                </a>
            </div>
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
                    <button href="#funcionamiento"> Saber más </button>
               </div>
            </div>


            <div className='der'>
                <img className='img-quienes-somos' src={ require('../../assets/estudiando-img.png') } />
            </div>


       </section>

       <section className='funcionamiento' id='funcionamiento'>
        
            <div className='izq'>
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
               
               <div className='arriba'>
                    <div className='contenedor-pasos'>
                        <div className='circulo'>
                            <FaPen />
                        </div>
                        <div className='descripcion-paso'>
                            <b>Paso 1</b>
                            <p>Registratrarse en la plataforma del PAE</p>
                        </div>
                    </div>
                    <div className='contenedor-pasos'>
                        <div className='circulo'>
                            <FaBookmark />
                        </div>
                        <div className='descripcion-paso'>
                            <b>Paso 2</b>
                            <p>Solicita una asesoria y manda tu duda especifica.</p>
                        </div>
                    </div>
               </div>


               <div className='abajo'>
                     <div className='contenedor-pasos'>
                        <div className='circulo'>
                            <FaAddressBook />
                        </div>
                        <div className='descripcion-paso'>
                            <b>Paso 3</b>
                            <p>Espera la asignacion de un asesor</p>
                        </div>
                    </div>
                    <div className='contenedor-pasos'>
                        <div className='circulo'>
                            <FaHandsHelping />
                        </div>
                        <div className='descripcion-paso'>
                            <b>Paso 4</b>
                            <p>Asiste a la asesoria en lugar y momento indicado.</p>
                        </div>
                    </div>
               </div>
               <button className='btn-final-pasos'>
                <FaChevronDown />
               </button>
       </section>

       <section className='objetivos' id='objetivos'>
            
            <div className='izq'>
               <h1>Objetivos</h1>
               <p>
                    El Programa Asesor Estudiante, mejor conocido como
                    el PAE, busca apoyar a nuestros alumnos a través de
                    asesorías impartidas por sus mismos compañeros de
                    carrera, mediante dichas asesorías, nuestros
                    estudiantes podrán compartir dudas y experiencias
                    con chavos de su misma edad, quienes les explicarán,
                    de una manera mucho más sencilla, los contenidos de
                    sus materias.
               </p>
            </div>

            <div className='der'>
               <img  className='img-objetivos' src={ require('../../assets/estudiando3-img.png') } alt='PAE' />
            </div>    
        </section>

       <section className='equipo-trabajo' id='equipo-trabajo'>
            
               <div className='titulo-equipo-trabajo'>
                    <h1>Equipo de trabajo</h1>
               </div>
               <div className='contenedor-cartas'>
                    <div className='carta'>
                        <img  src={ require('../../assets/perfil-equipo-trabajo-img.png') } alt='PAE' />
                        <b>CYNTHIA MARLENE VEGA GÓMEZ</b>
                        <p>Directora de Bienestar Estudiantil</p>
                    </div>
                    <div className='carta'>
                        <img  src={ require('../../assets/perfil-equipo-trabajo-img.png') } alt='PAE' />
                        <b>EVANGELINA FINNEY CABAÑAS</b>
                        <p>Líder de Mejoramiento Académico</p>
                    </div>
                    <div className='carta'>
                        <img  src={ require('../../assets/perfil-equipo-trabajo-img.png') } alt='PAE' />
                        <b>DANIELA VILLEGAS MONCAYO</b>
                        <p>Coordinadora de PAE</p>
                    </div>
               </div>


       </section>
    </>
  )
}

export default LandingPage;
import React, { useState } from 'react'
import { TarjetaListaDesplegable } from '../../../routeIndex';

import { FaAngleDown,FaAngleUp } from "react-icons/fa";
import './listaDesplegable.css';

const COLORES_TIPO_1 = [
    "azul_tipo_1",
    "amarillo_tipo_1",
    "rojo_tipo_1",
    "azul_tipo_1",
    "amarillo_tipo_1",
    "rojo_tipo_1",
    "azul_tipo_1",
    "amarillo_tipo_1",
    "rojo_tipo_1"
];



const ListaDesplegable = ( { tipo, semestre, fecha, arrContenido, getUFSelected } ) => {


    /*
        DOCUMENTACION DEL COMPONENTE

        Notas importantes:
            -> El uso de un json solo es una simulacion para poder probar los componentes, 
            de hecho, los arreglos recibidos en la propiedad de "arrContenido", deberian ser pasados desde el componente o view
            de donde se este mandando a llamar el componente, esto despues de extraerlo toda esa informacion del json de verdad.

            -> los datos del archivo json deben de estar acomodados de la manera como si indica en el json de ejemplo (data.json)

            -> Existen dos tipo de ListaDesplegable:
                    1 => es la lista desplegable chica, la cual solo aparece la clave de la UF y el Nombre, es decir, la listaDesplegable de semestre
                    2 => es la lista desplegable grande, aparecen las citas agendadas en en la seccion de directivos.

            -> Es importante siempre mandar el property de tipo, ya que podria marcar un error

            -> Con propocitos de prueba del componente, se crea un json de prueba (data.json) pero se debera asignar el array de informacion desde el componente op 
            view en donde se mande a llamar.

            -> Es importante manejar la informacion recibida en la propiedad "arrContenido", ya que depederá del tipo de lista con la que se 
            vaya a trabajar, se sugiere mandar esta información a traves de un objeto, dependiendo del tipo de ListaDesplegable que se vaya a usar.
        
                Si se va usar el tipo 1 === usar una estructura como se muestra en el objeto de arriba llamado "listaChica".

                Si se va usar el tipo 2 === usar una estructura como se muestra en el objeto de arriba llamado "listaGrande".
                    Nota** -> en el atributo color_Tipo3 es importante basarse en los colores de "COLORES_TIPO_1" de la parte de arriba.

        Uso:

            tipo : dato entero con el que especificamos que tipo de lista se quiere.
            semestre: dato entero, con el podemos saber el semestre del que se habla
            fecha: dato de string, recibimos la fecha para el tipo de lista 2
            arrContenido: Un objeto, en donde se guarden las cosas a deplegar en la lista.

        Ejemplo de uso:

            De tipo 1: 
           <ListaDesplegable tipo={ 1 } semestre={1}  arrContenido={ objeto_info }/> 

           De tipo 2:
          <ListaDesplegable tipo={ 2 } fecha="7 de marzo del 2022" arrContenido={ objeto_info } />


    
    */

    const [active, setActive] = useState(false);
    const handleActive = () => {
        setActive(!active);
    }

    const BackgroundColorTipo1 = semestre !== 0 ? COLORES_TIPO_1[semestre-1] : COLORES_TIPO_1[0];
    // const BackgroundColorTipo1 = COLORES_TIPO_1[semestre-1];

    const selectUF = infoUF => {
        getUFSelected({ ...infoUF, semestre: semestre })
    } 

  return (
    <>
        {
            tipo === 1 ?
            (
                <div className='contenedor-listaDesplegable'>
                    <div className={ `header-listaDesplegable ${BackgroundColorTipo1}` } >

                        <p> Semestre {semestre} </p>
                        {
                            active === true ?
                            (
                                <FaAngleUp 
                                    className='icono-listaDesplegable'
                                    onClick={ handleActive }>
                                </FaAngleUp>
                            ):
                            (
                                <FaAngleDown 
                                    className='icono-listaDesplegable'
                                    onClick={ handleActive } >
                                </FaAngleDown>      
                            )

                        }
                    
                    </div>
            
                    <div className={ "contenido-listaDesplegable" + ( active === true ? " show" :"" ) }>
                        <div className='container-listaDesplegable'>
                            
                            {
                                arrContenido.map((materia, index) => (
                                    
                                    <TarjetaListaDesplegable 
                                        tipo={1} 
                                        claveUF={materia.claveUF} 
                                        nombreUF={ materia.nombreUF } 
                                        colorTipo1="blanco_tipo_1" 
                                        getUFSelected={ selectUF }
                                        key={index}
                                    />
                                ))
                            }
                        </div>
                
                    </div>
                </div>
            )
            :
            tipo === 2 ? 
            (
                <div className='contenedor-listaDesplegable-2'>
                    <div className={ `header-listaDesplegable-2` } >

                        <p> { fecha } </p>
                        {
                            active === true ?
                            (
                                <FaAngleUp 
                                    className='icono-listaDesplegable'
                                    onClick={ handleActive }>
                                </FaAngleUp>
                            ):
                            (
                                <FaAngleDown 
                                    className='icono-listaDesplegable'
                                    onClick={ handleActive } >
                                </FaAngleDown>      
                            )

                        }
                
                    </div>
        
                    <div className={ "contenido-listaDesplegable" + ( active === true ? " show" :"" ) }>
                        <div className='container-listaDesplegable-2'>


                            {
                                arrContenido.map((cita, index) => (
                                    <TarjetaListaDesplegable 
                                        tipo={ 3 } 
                                        claveUF={ cita.claveUF } 
                                        colorTipo3={ cita.colorTipo3 } 
                                        horaAsesoria={ cita.horaAsesoria } 
                                        contenido={ cita.contenido }
                                        accion={ ()=>{ window.alert("Abrir PopUpInformacionAsesoria") } }
                                        key={index}
                                    />
                                ))
                            }

                        </div>
            
                    </div>
                </div>
            )
            :
            (
                <div className='contenedor-listaDesplegable'>
                    <div className={ `header-listaDesplegable negro_tipo_3` } >

                        <p> Seleccionar asesor: </p>
                    </div>
            
                    <div className={ "contenido-listaDesplegable-3 show" }>
                        <div className='container-listaDesplegable'>
                            
                            {
                                arrContenido.map((asesor, index) => (
                                    
                                    <TarjetaListaDesplegable 
                                        tipo={5} 
                                        matricula={asesor.matricula} 
                                        nombreAsesor={ asesor.nombre } 
                                        colorTipo1="blanco_tipo_1" 
                                        key={index}
                                    />
                                ))
                            }
                        </div>
                
                    </div>
                </div>
            )
        }
        
    </>
  )
}

export default ListaDesplegable 
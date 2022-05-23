import React, { useRef, useState } from 'react'
import { PreguntaCerradaEncuesta, PreguntaAbiertaEncuesta, ImagenAsesoria } from '../../../routeIndex';
import { useIsOverflowX } from '../../../hooks/useIsOverflowX';
import ImageUploading from "react-images-uploading";
import { FaFileUpload } from "react-icons/fa";
import './popUpEncuesta.css';




const data = [
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

    },
    {
        tipoDePregunta:"abierta",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

    }

]

const data2 = [
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: 9

    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: 3
    },
    {
        tipoDePregunta:"abierta",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: "Mucho texto muy explicito."
    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: 6

    },
    {
        tipoDePregunta:"cerrada",
        pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
        respuesta: 8

    }

]




const PopUpEncuesta = ({ 
    tipo=3, 
    nombreEvaluado="Daniel Maldonado", 
    preguntas = data, 
    respuestasAsesorado=[], 
    respuestasAsesor=data2, 
    imagenResultados="imgPruebaPopUpEncuesta.webp", 
    activo, 
    ocultarPopUp
} ) => {

    /*
        DOCUMENTACION DEL COMPONENTE

        Notas importanes:
            -> para este componente existen 3 tipos de diferente visualizacion y funcionamiento
            las cuales se definen a contunuación:
                -> 1 == PopUp de encuesta de asesorado
                -> 2 == PopUp de encuesta de asesor
                -> 3 == vuzualizacion de resultados de encuestas para los directivos
            -> la informacion recibida debera de ser a traves de un objeto de js, tanto para las preguntas totales
            y para poder saber las respuestas contestadas de los asesores y asesorados.
        
        Uso:
            -> para usar este componente, se requiere que se pasen propiedades, las cuales se definien a continuación:
                
                -> tipo => dvalor entero, definimos que tipo de PopUpEncuesta se mostrará en pantalla, tal como se me mencionó
                anteriormente, los valores validos son los siguientes :
                    -> 1 == PopUp de encuesta de asesorado
                    -> 2 == PopUp de encuesta de asesor
                    -> 3 == vuzualizacion de resultados de encuestas para los directivos
                
                -> 
    */



    const btnNoLlegadaAsesorado = () => {
        window.alert("no llegó el asesorado");
    };
    const btnNoLlegadaAsesor = () => {
        window.alert("no llegó el asesor");
    };

    // usamos el custom hook, le mandamos la referencia del elemento 
    const ref = useRef();
    const isOverflow = useIsOverflowX(ref);

    const [images, setImages] = React.useState([]);
    const onChange = (imageList) => {
        setImages(imageList);
    };


  return (
    <>
        <div className={ `fondo-display-PopUpEncuesta-responder ${ activo ? '':'ocultarEncuesta' }` }>
            {
                tipo === 3 ?
                (
                    <div className='contenedor-encuesta'>

                        <div className='encabezado-contenedor-encuesta-tipo3'>
        
                            <div className='encabezado-izq-encuesta'>
                                <p className='encabezado-izq-encuesta-texto'>
                                    Encuesta de experiencia y mejora de asesoria con { nombreEvaluado }
                                </p>
                            </div>
                            
                        </div>
        
        
                        <div className='contenido-contenedor-encuesta' ref={ ref }>
        
                            {
                                isOverflow?
                                (
                                    <div className={ `contenedor-espacio-encuesta-${ respuestasAsesorado.length > 0 ? '1':'2' }` }></div>
                                ):
                                (
                                    <></>
                                )
                            }
        
                            {
                                respuestasAsesor.length > 0  ?
                                (
                                    <div className='contenedor-pregunta-encuesta-imagen-tipo3'>
                                        <h4>Evidencia de asesoria</h4>
                                        <img className='imagen-encuesta-tipo3' src={require( `../../../assets/${imagenResultados}` )} alt="imagenChida" />
                                    </div>
                                ):
                                (
                                    <></>
                                )
                            }
        
                            {
                                respuestasAsesorado.length > 0? 
                                (
                                    respuestasAsesorado.map((preg, index) => (
                                        preg.tipoDePregunta === "cerrada" ?
                                        (
                                            <div className='contenedor-pregunta-encuesta-cerrada'>
                                                <PreguntaCerradaEncuesta 
                                                    preguntaCerrada=" ¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl? " 
                                                    indexPregunta= {index+1}
                                                    respuesta ={ preg.respuesta }
                                                />
                                            </div>
                                        ):
                                        (
                                            <div className='contenedor-pregunta-encuesta-abierta'>
                                                <PreguntaAbiertaEncuesta
                                                    preguntaAbierta=" ¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl? "
                                                    indexPregunta={ index+1 }
                                                    respuesta = { preg.respuesta }
                                                    
                                                />
                                            </div>
                                        )
                                    ))
                                ):
                                (
                                    respuestasAsesor.map((preg, index) => (
                                        preg.tipoDePregunta === "cerrada" ?
                                        (
                                            <div className='contenedor-pregunta-encuesta-cerrada'>
                                                <PreguntaCerradaEncuesta 
                                                    preguntaCerrada=" ¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl? " 
                                                    indexPregunta= {index+1}
                                                    respuesta = { preg.respuesta }

                                                />
                                            </div>
                                        ):
                                        (
                                            <div className='contenedor-pregunta-encuesta-abierta'>
                                                <PreguntaAbiertaEncuesta
                                                    preguntaAbierta=" ¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl? "
                                                    indexPregunta={ index+1 }
                                                    respuesta = { preg.respuesta }

                                                />
                                            </div>
                                        )
                                    ))
                                )
                                
                            }
        
                        </div>
        
                        <div className='footer-contenedor-encuesta'>
                            <button className='boton-footer-encuesta-tipo3' onClick={ocultarPopUp}> Cerrar </button>
                        </div>
                    </div>
                ):  //=================================================================================================
                (
                    <div className='contenedor-encuesta'>


                    <div className='encabezado-contenedor-encuesta'>
    
                        <div className='encabezado-izq-encuesta'>
                            <p className='encabezado-izq-encuesta-texto'>
                                Encuesta de experiencia y mejora de asesoria con { nombreEvaluado }
                            </p>
                        </div>
    
                        <div className='encabezado-der-encuesta'>
                            {
                                tipo === 1 ?
                                (
                                    <button 
                                    onClick={ btnNoLlegadaAsesor } 
                                    className='btn-encabezado-encuesta'
                                    >
                                        No llegó el asesor
                                    </button>
                                ):
                                (
                                    <button 
                                    onClick={ btnNoLlegadaAsesorado } 
                                    className='btn-encabezado-encuesta'
                                    >
                                        No llegó el asesorado
                                    </button>
                                )
                            }
                        
                        </div>
                        
                    </div>
    
    
                    <div className='contenido-contenedor-encuesta' ref={ ref }>
    
                        {
                            isOverflow?
                            (
                                <div className={ `contenedor-espacio-encuesta-${tipo}` }></div>
                            ):
                            (
                                <></>
                            )
                        }
    
                        {
                            tipo === 2 ?
                            (
                                <div className='contenedor-pregunta-encuesta-imagen'>
                                    <ImageUploading multiple value={images} onChange={onChange} maxNumber={1} dataURLKey="data_url">
                                        {({ imageList, onImageUpload, onImageRemove }) => (
                                        <div className="contenedor-subirImg">
                                            <div className='container_imagenes_RegistroAsesor'>
                                                {imageList.length === 0 ? 
                                                <p 
                                                    className='texto-evidencia-encuesta'
                                                    onClick={onImageUpload}>Evidencia de asesoría <FaFileUpload/></p>
                                                : imageList.map((image, index) => (
                                                    <ImagenAsesoria
                                                        allowClosed = '1'
                                                        onClickX = {() => onImageRemove(index)}
                                                        size = 'reducida'
                                                        source = {image.data_url}
                                                        alt = {`ImagenAsesoria${index}`}
                                                        nameDownloadImage = {`ImagenAsesoria${index}`}
                                                    />
                                                ))}
                                            </div>
                                        </div>
                                        )}
                                    </ImageUploading>
                                </div>
                            ):
                            (
                                <></>
                            )
                        }
    
                        {
                            preguntas.map((preg, index) => (
                                preg.tipoDePregunta === "cerrada" ?
                                (
                                    <div className='contenedor-pregunta-encuesta-cerrada'>
                                        <PreguntaCerradaEncuesta 
                                            preguntaCerrada=" ¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl? " 
                                            indexPregunta= {index+1}
                                        />
                                    </div>
                                ):
                                (
                                    <div className='contenedor-pregunta-encuesta-abierta'>
                                        <PreguntaAbiertaEncuesta
                                            preguntaAbierta=" ¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl? "
                                            indexPregunta={ index+1 }
                                        />
                                    </div>
                                )
                            ))
                        }
    
                    </div>
    
                    <div className='footer-contenedor-encuesta'>
                        <button className='boton-footer-encuesta' onClick={ ocultarPopUp }  > Enviar </button>
                    </div>
                </div>
                )
            }
           
        </div>


    </>
  )
}

export default PopUpEncuesta
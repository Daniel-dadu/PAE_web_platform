import React, { useRef } from 'react'
import { PreguntaCerradaEncuesta, PreguntaAbiertaEncuesta, ImagenAsesoria } from '../../../routeIndex';
import { useIsOverflowX } from '../../../hooks/useIsOverflowX';
import ImageUploading from "react-images-uploading";
import { FaFileUpload } from "react-icons/fa";
import './popUpEncuesta.css';



// PARTE DE LA DOCUMENTACION =======================================================================
// const data = [
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

//     },
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

//     },
//     {
//         tipoDePregunta:"abierta",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

//     },
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

//     },
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",

//     }

// ]

// const data2 = [
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
//         respuesta: 9

//     },
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
//         respuesta: 3
//     },
//     {
//         tipoDePregunta:"abierta",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
//         respuesta: "Mucho texto muy explicito."
//     },
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
//         respuesta: 6

//     },
//     {
//         tipoDePregunta:"cerrada",
//         pregunta:"¿Lorem ipsum dolor sit amet, consectetur adipiscing elit. In tellus nisl?",
//         respuesta: 8

//     }

// ]
// ==================================================================================================



const PopUpEncuesta = ({ 
    tipo, 
    nombreEvaluado, 
    preguntas, 
    respuestasAsesorado=[], 
    respuestasAsesor=[], 
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
            -> se recomienda usar este componente fuera de la tarjeta madre o plantilla, para obtener un centrado del PopUp
            mucho mejor.
            
        
        Uso:
            -> para usar este componente, se requiere que se pasen propiedades, las cuales se definien a continuación:
                
                -> tipo => de valor entero, definimos que tipo de PopUpEncuesta se mostrará en pantalla, tal como se me mencionó
                anteriormente, los valores validos son los siguientes :
                    -> 1 == PopUp de encuesta de asesorado
                    -> 2 == PopUp de encuesta de asesor
                    -> 3 == vuzualizacion de resultados de encuestas para los directivos
                
                -> nombreEvaluado => de valor string, definimos el nombre de la persona que está siendo evaluada en el componente
                para que aparezca en el encabezado.
                
                ->preguntas => objeto en el que podremos recibir valores de las preguntas que conformarán el formulario
                en la parte de arriba, en el objeto 'data', se da un ejemplo del formato que debe llevar dicha propiedad.

                -> respuestasAsesorado => objeto que sirve para poder obtener las respuestas de las encuestas ya realizadas
                con el fin de mostrarlos en el tipo de PopUp 3 (visualización). en la parte de arriba, se muestra un ejemplo de la
                estructura de dicho objeto 'data2', lo dejamos como objeto vacio default cuando no se requiere mostrar las respuestas de asesorados

                -> respuestasAsesor => bjeto que sirve para poder obtener las respuestas de las encuestas ya realizadas
                con el fin de mostrarlos en el tipo de PopUp 3 (visualización). en la parte de arriba, se muestra un ejemplo de la
                estructura de dicho objeto 'data2', lo dejamos como objeto vacio default cuando no se requiere mostrar las respuestas de asesores.

                -> activo => booleano, usado para poder determinar si se muestra o no el componente, se recomienda usar useState desde
                el componente padre o vista en donde se este invocando el componente PopUpEncuesta, como se muestra a continuación:
                
                const [activoEncuesta, setActivoEncuesta] = useState(false);

                de esta manera podemos enviar la variable activoEncuesta a esta propiedad (activo).

                ->ocultarPopUp => funcion que es invocada desde el componente padre o vista en donde se este invocando el componente
                para poder ocultar dicho PopUp. Se recomienda tener una funcion declarada como se muestra a continuación: 

                const cerrarEncuesta = () => {
                    setActivoEncuesta(!activoEncuesta);
    
                };

                y enviarla en esta propiedad del componente ("ocultarPopUp").

        Ejemplo de uso:
                
                Para el tipo 1 :
                <PopUpEncuesta tipo={1} nombreEvaluado="Daniel Maldonado" preguntas={ data } activo={activoEncuesta} ocultarPopUp={cerrarEncuesta} />
                
                Para el tipo2:
                <PopUpEncuesta tipo={2} nombreEvaluado="Daniel Maldonado" preguntas={ data } activo={activoEncuesta} ocultarPopUp={cerrarEncuesta} />

                Para el tipo3 (respuestas de asesores):
                <PopUpEncuesta tipo={3} nombreEvaluado="Daniel Maldonado" respuestasAsesor={ data2 } activo={activoEncuesta} ocultarPopUp={cerrarEncuesta} />

                Para el tipo3 (respuestas de asesorados ):
                <PopUpEncuesta tipo={3} nombreEvaluado="Daniel Maldonado" respuestasAsesorado={ data2 } activo={activoEncuesta} ocultarPopUp={cerrarEncuesta} />

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
                            isOverflow &&
                            <div className={ `contenedor-espacio-encuesta-${tipo}` }></div>
                          
                        }
    
                        {
                            tipo === 2 &&
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
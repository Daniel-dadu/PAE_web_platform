import React from 'react';
import { ListaDesplegable, BotonSencillo } from '../../../routeIndex';
import { ImCross } from "react-icons/im";
import './popUpSolicitudAsesoria.css';

var matriculaAsesor;

const info = {
    fecha:{
        "dia":9,
        "mes":"marzo",
        "hora":"3:00 PM"
    },
    asesorado:"Ezequiel Lozano",
    unidadFormacion: "Fundamentos químicos",
    duda:"Aquí debe ir mucho texto que describa la duda que tiene el alumno y debe estar escrita de la forma más específica posible.",
    imagenes:{
        img1:"https://bobbyhadz.com/images/blog/react-image-link/banner.webp",
        img2:"https://i.redd.it/rt5xnrhm93s51.jpg",
        img3:"https://www.ionos.mx/digitalguide/fileadmin/DigitalGuide/Screenshots_2020/screenshot-windows-10-1.png"
    }, 
    asesores: [
        {
            "matricula":"A01734184",
            "nombre":"Daniel Flores"
        },
        {
            "matricula":"A01734184",
            "nombre":"Daniel Flores"
        },
        {
            "matricula":"A01734184",
            "nombre":"Daniel Flores"
        },
        {
            "matricula":"A01734184",
            "nombre":"Daniel Flores"
        },
        {
            "matricula":"A01734184",
            "nombre":"Daniel Flores"
        }
    ]
}


const PopUpSolicitudAsesoria = ({ data = info, activo, accion, accionCancelar, accionConfirmar }) => {

    /*
        DOCUMENTCION DEL COMPONENTE

            notas importantes:
                -> se debera poner el componente fuera del templete donde se este trabajando, de esta manera el centrado y 
                será mejor.
                -> se recomienda usar un hook de useState, para que se pueda controlar el display del elemento, y asi se pueda 
                iterar la aparición del PopUp en el componente o la view padre donde se está invocando, como se muestra a continuación:
                ======================================================
                     const [active, setActive] = useState(false);

                    const handleActive = () => {
                        setActive(!active);
                    }
                ======================================================
                

            uso:
                Propiedades:
                    -> data. objeto que recibe la informacion que se mostrará en el PopUp. El formato de este se muestra en el objeto definido
                    arriba llamado "info"
                    ->activo. booleano, estado de nuestro hook useState.
                    ->accion. función que hará que cambie el estado de el estado del hook useState
            
                    
            ejemplo de uso:

                <PupUpSolicitudAsesoria  data={objeto_info} activo={active} accion={ handleActive } />
                    
    */

    const onSelectAsesor = matricula => {
        matriculaAsesor = matricula;
    }

  return (
        <>
            <div className={ `contenedor-general-PuSolicitudAsesoria${activo?"":" show"}` }>
                <div className='contenedor-PuSolicitudAsesoria'>
                    
                    <div className='encabezado-PuSolicitudAsesoria'>
                        
                        <h1>Solicitud de Asesoria</h1>
                        <div className='close-btn' onClick={ accion }>
                            <ImCross className='cross-cerrar' onClick={ accion }/>
                        </div>

                    </div>
                    <div className='contenido-PuSolicitudAsesoria'>

                        <div id='relleno-popUpAsesoria'></div>
                        <div id='relleno-popUpAsesoria'></div>
                        <div id='relleno-popUpAsesoria'></div>
                        <div id='relleno-popUpAsesoria'></div>
                        <div id='relleno-popUpAsesoria'></div>
                        <div id='relleno-popUpAsesoria'></div>
                        
                        <div className='contenedor-fechayhora' >
                            <b id='letras-negritas'> Fecha y hora: </b>
                            <p> { data.fecha.dia } de { data.fecha.mes } a las { data.fecha.hora } </p>

                        </div>
                        <div className='contenedor-asesorado'> 
                            <b id='letras-negritas'>Asesorado: </b>
                            <p> { data.asesorado } </p>
                        </div>
                        <div className='contenedor-unidadFormacion'>
                            <b>Unidad de formacion:</b>
                            <p> { data.unidadFormacion } </p>

                        </div>
                        <div className='contenedor-duda'>
                            <b>Duda:</b>
                            <p> { data.duda } </p>
                        </div>
                        <div className='contenendor-imagenes'>
                            <b>Imagenes adjuntadas</b>
                            <div className='galeria-imagenes'>
                                {
                                    (data.imagenes['img1'] !== null)
                                        ? <img src={ data.imagenes.img1 } alt="img1" id="img-mostrada" />
                                        : <> <br/><br/><br/><br/><br/> <p>No se adjuntaron imágenes</p> </>
                                }
                                {
                                    (data.imagenes['img2'] !== undefined)
                                        ? <img src={ data.imagenes.img2 } alt="img2" id="img-mostrada" />
                                        : <p></p>
                                }
                                {
                                    (data.imagenes['img3'] !== undefined)
                                        ? <img src={ data.imagenes.img3 } alt="img3" id="img-mostrada" />
                                        : <p></p>
                                }
                            </div>
                        </div>
                        <div className='separador-contenido-popUp'>
                            <b>Informacion por determinar</b>
                        </div>
                        <div className='contenedor-lugarAsesoria'>
                            <b id='letras-negras-column'>Lugar de asesoria:</b>
                            <input type="text" name="lugar_asesoria" id="lugar_asesoria" />
                        </div>
                        <div className='contenedor-asesores'>
                            
                            <ListaDesplegable tipo={ 3 } arrContenido={ data.asesores } getAsesorSelected={ onSelectAsesor } />  

                        </div>
                    </div>
                    <div className='footer-PuSolicitudAsesoria'>
                            <BotonSencillo  backgroundColor="rojo" size="reducido" children="cancelar asesoria" onClick={ accionCancelar }/>
                            <BotonSencillo  backgroundColor="verde" size="reducido" children="confirmar asesoria" onClick= {() => accionConfirmar(matriculaAsesor)}/>

                    </div>
                </div>
            </div>
        </>
  )
}

export default PopUpSolicitudAsesoria
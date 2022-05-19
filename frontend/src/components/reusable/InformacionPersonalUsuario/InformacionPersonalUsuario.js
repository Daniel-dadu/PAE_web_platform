import React, { useState } from 'react';
import { FaPen } from "react-icons/fa";
import { BiImageAdd } from 'react-icons/bi';
import { CampoSeleccionarEnListaDesplegable, 
    CampoTextoPequeno, 
    BotonSencillo, 
    ImagenAsesoria,BotonConImagen } from '../../../routeIndex';
import './informacionPersonalUsuario.css';
import data from './data.json';
import ImageUploading from "react-images-uploading";



const InformacionPersonalUsuario = () => {

    const [editar, setEditar] = useState(false);
    const [previewImage, setPreviewImage] = useState([]);
    const onChange = (imageList) => {
        setPreviewImage(imageList);
        console.log(imageList);
   };

    const handleEditarPerfil = () => {
        setEditar(!editar);
    }

    const informacion = {
        nombre: "Mario Alonso",
        matricula: "A01734184",
        carrera: ["ITC","IRS"],
        semestre: 1,
        telefono: 222777888
    }

    const armarCadenaCarrea = (carreras) => {
        let cadena ="";
        for( let i = 0; i<carreras.length ; i++ ){
            if( i === carreras.length - 1 )
                cadena += carreras[i];
            else
            cadena += carreras[i] + ', ';

        }

        return cadena;
    }


  return (
    <>
        <div className='contenedor-general-InfPerUsuario'>

            {
                !editar ?
                (

                    <div className='contenedor-InfPerUsuario'>
                        <div className='contenedor-InfPerUsuario-izq' >

                            <div className='contenedor-img-perfil-InfPerUsuario'>
                                <img src={ require( `../../../assets/img-editar-perfil-tmp.JPG` ) } alt="imgProfile" className='imagen-InfPerUsuario'/>
                                <button className='btn-editar-InfPerUsuario' onClick={ handleEditarPerfil }>
                                    <div className='contenedor-btn-editar-InfPerUsuario'>
                                        <p className='btn-texto-InfPerUsuario'>Editar</p>
                                        <FaPen/>
                                    </div>
                                </button>
                            </div>

                        </div>
                        <div className='contenedor-InfPerUsuario-der' >

                            <p className='etiqueta-nombre-InfPerUsuario' >{ informacion.nombre }</p>
                            <p className='etiqueta-matricula-InfPerUsuario' >{ informacion.matricula }</p>
                            <p className='etiqueta-carrera-InfPerUsuario' > Carrera(s): { ( (informacion.carrera.length == 1) ? informacion.carrera[0] : armarCadenaCarrea(informacion.carrera)) }</p>
                            <p className='etiqueta-semestre-InfPerUsuario' > Semestre: { informacion.semestre }</p>
                            <p className='etiqueta-telefono-InfPerUsuario' > Telefono: { informacion.telefono }</p>

                        </div>
                    </div>
                )
                :
                (

                    <div className='contenedor-InfPerUsuario'>
                        <div className='contenedor-InfPerUsuario-izq-actualizar-img' >

                        <ImageUploading multiple value={previewImage} onChange={onChange} maxNumber={1} dataURLKey="data_url">
                            {({ imageList, onImageUpload, onImageRemove }) => (
                            <div className="container_ImageUploading_RegistroAsesor">
                                <div className='container_imagenes_RegistroAsesor'>
                                    {imageList.length === 0 ? 
                                    <img 
                                        src={ require( `../../../assets/img-editar-perfil-tmp.JPG` ) } 
                                        alt="imgProfile" 
                                        className='imagen-InfPerUsuario-actualizar-img'
                                    />

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

                                <div className='btn_upload'>
                                    <BotonConImagen 
                                    onClick={imageList.length === 1 ? () => alert('No se permite subir más de 1 imagen') : onImageUpload} 
                                    backgroundColor="azulCielo" 
                                    size="largo" 
                                    Image={BiImageAdd} >
                                        Subir imagen
                                    </BotonConImagen>
                                </div>
                            </div>
                )}
            </ImageUploading>

                        </div>
                        <div className='contenedor-InfPerUsuario-der' >

                            <p className='etiqueta-nombre-InfPerUsuario' >{ informacion.nombre }</p>
                            <p className='etiqueta-matricula-InfPerUsuario-2' >{ informacion.matricula }</p>
                            <p className='etiqueta-carrera-InfPerUsuario' > Carrera: </p><CampoSeleccionarEnListaDesplegable size="big"  idList="carrera" options={ data.carrera } />
                            <p className='etiqueta-carrera-InfPerUsuario' > Carrera 2: </p><CampoSeleccionarEnListaDesplegable size="big"  idList="carrera" options={ data.carrera } />
                            <p className='etiqueta-semestre-InfPerUsuario'> Semestre: </p><CampoSeleccionarEnListaDesplegable size="small" idList="semestre" options={ data.semestre } />
                            <p className='etiqueta-telefono-InfPerUsuario'> Telefono </p><CampoTextoPequeno size="medium"/>

                            <div className='contenedor-btn-editar'>

                                <BotonSencillo  onClick={ handleEditarPerfil } backgroundColor="gris" size="normal" children="Cancelar" />
                                <BotonSencillo  onClick={ handleEditarPerfil } backgroundColor="verde" size="normal" children="Confirmar" />

                            </div>

                        </div>
                    </div>

                )
            }


        </div>
    </>
  )
}

export default InformacionPersonalUsuario
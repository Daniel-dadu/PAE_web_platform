import React from 'react'

import { TemplateRegistroUsuario, CampoTextoPequeno, ImagenAsesoria, CampoSeleccionarEnListaDesplegable, BotonConImagen } from '../../../routeIndex'


import ImageUploading from "react-images-uploading";
import { BiImageAdd } from 'react-icons/bi'
import info from './info.json'

import "./RegistroAsesoradoDatos.css"

let progressBar = {
    "currentStep": 0,
    "steps": [
        {
            "name" : "Datos Generales",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesoradoDatos"
          }, 
          {
            "name" : "Consideraciones Finales",
            "state": null,
            "next": "enable",
            "path" : "./registroAsesoradoCondiciones"
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "./registroAsesoradoResumen"
          }
    ]
  }

function RegistroAsesoradoDatos() {

    const [images, setImages] = React.useState([]);
    const onChange = (imageList) => {
         // console.log(imageList);
        setImages(imageList);
    };


  return (
    <TemplateRegistroUsuario 
    progressBarJSON = {progressBar}
     btnAtrasRoute="/landingPage"
     btnSiguienteRoute="./registroAsesoradoCondiciones"> 

<div>
            <h1 className='campo_RegistroAsesoradoDatos'> CAMPO 1: Datos generales </h1>

          
          </div>

        <div className='contener_DatosAsesoradoInputRegistro'> 

        <div className='contenedro_deInputsAsesoradoRegistro'> 
            <div className='texto_contenedor_deInputsAsesoradoRegistro'> Nombre (s) </div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesoradoRegistro'> 
            <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Paterno </div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesoradoRegistro'> 
            <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Materno </div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesoradoRegistro'> 
            <div className='texto_contenedor_deInputsAsesoradoRegistro'> Matrícula</div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesoradoRegistro'> 
            <div className='texto_contenedor_deInputsAsesoradoRegistro'> Carrera  </div>
            <CampoSeleccionarEnListaDesplegable size="medium" options={info.carrera} idList="semestre"/>
        </div>


        <div className='contenedro_deInputsAsesoradoRegistro'> 
            <div className='texto_contenedor_deInputsAsesoradoRegistro'> Número de teléfono (opcional)  </div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='imeges_contenedro_deInputsAsesoradoRegistro'> 
            <div className='texto_contenedor_deInputsAsesoradoRegistro'> Imagen de Perfil </div>
            

            <ImageUploading multiple value={images} onChange={onChange} maxNumber={1} dataURLKey="data_url">
                {({ imageList, onImageUpload, onImageRemove }) => (
                <div className="container_ImageUploading_RegistroAsesorado">
                    <div className='container_imagenes_RegistroAsesorado'>
                        {imageList.length === 0 ? 
                        <p>No se ha subido ninguna imagen</p>
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


        </div>
        






   
   
    </TemplateRegistroUsuario>
  )
}

export default RegistroAsesoradoDatos
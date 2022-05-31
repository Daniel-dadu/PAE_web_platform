import React from 'react'

import { TemplateRegistroUsuario, CampoTextoPequeno, ImagenAsesoria, CampoSeleccionarEnListaDesplegable, BotonConImagen } from '../../../routeIndex'

import info from './info.json'

import "./RegistroAsesorDatos.css"

import ImageUploading from "react-images-uploading";
import { BiImageAdd } from 'react-icons/bi'

let progressBar = {
    "currentStep": 0,
    "steps": [
        {
            "name" : "Datos Generales",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesorDatos"
          }, 
          {
            "name" : "Horario",
            "state": null,
            "next": "enable",
            "path" : "Ruta"
          },
          {
            "name" : "Unidad de Formacion",
            "state": null,
            "next": "enable",
            "path" : "Ruta"
          },
          {
            "name" : "Consideraciones Finales",
            "state": null,
            "next": "enable",
            "path" : "./registroAsesorCondiciones"
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "Ruta"
          }
    ]
  }

function RegistroAsesorDatos() {

    const [images, setImages] = React.useState([]);
    const onChange = (imageList) => {
         // console.log(imageList);
        setImages(imageList);
    };

  return (
    <TemplateRegistroUsuario 
    progressBarJSON = {progressBar}
     btnAtrasRoute='/landingPage'
     btnSiguienteProps={{ view: 1, props: null }}
     isRegistroAsesor={true}> 

        <div>
            <h1 className='campo_RegistroAsesorDatos'> CAMPO 1: Datos generales </h1>

            <h1 className='datosAsesor_texto'> * Los campos con asteríscos son obligatorios </h1>
          
          </div>

        <div className='contener_DatosAsesorInputRegistro'> 

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Nombre (s) * </div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Apellido Paterno * </div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Apellido Materno </div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Matrícula *</div>
            <CampoTextoPequeno size={"big"}></CampoTextoPequeno>
        </div>

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Carrera * </div>
            <CampoSeleccionarEnListaDesplegable size="medium" options={info.carrera} idList="semestre"/>
        </div>

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> 2da Carrera * </div>
            <CampoSeleccionarEnListaDesplegable size="medium" options={info.carrera} idList="semestre"/>
        </div>

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Semestre* </div>
            <CampoSeleccionarEnListaDesplegable size="small" options={info.semestre} idList="carrera"/>
        </div>

        <div className='contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Número de teléfono </div>
            <CampoSeleccionarEnListaDesplegable size="medium" options={info.carrera} idList="semestre"/>
        </div>

        <div className='imeges_contenedro_deInputsAsesorRegistro'> 
            <div className='texto_contenedor_deInputsAsesorRegistro'> Imagen de Perfil </div>
            

            <ImageUploading multiple value={images} onChange={onChange} maxNumber={1} dataURLKey="data_url">
                {({ imageList, onImageUpload, onImageRemove }) => (
                <div className="container_ImageUploading_RegistroAsesor">
                    <div className='container_imagenes_RegistroAsesor'>
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

export default RegistroAsesorDatos
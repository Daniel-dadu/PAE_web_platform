import React, { useState } from 'react'
import { useParams } from "react-router-dom"
import ImageUploading from "react-images-uploading";
import './AgendarAsesoriaDuda.css'

import { AgendarAsesoria, BotonConImagen, ImagenAsesoria, CampoTextoGrande, imageCompressor } from '../../../routeIndex'

import { BiImageAdd } from 'react-icons/bi'

let progressBar = {
  "currentStep": 1,
  "steps": [
      {
          "name" : "Selección",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaUF"
        }, 
        {
          "name" : "Información",
          "state": true,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Fecha",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Hora",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
        },
        {
          "name" : "Confirmación",
          "state": null,
          "next": "enable",
          "path" : "./AgendarAsesoriaDuda"
      }
  ]
}
function AgendarAsesoriaDuda() {

  const { idasesoria } = useParams();

  /*
  IMPORTANTE!!!!!!!
  Es necesario hacer una verificación de que la asesoría que se recibe como parámetro en la ruta corresponda a ese usuario 
  y que el statusasesoria esté en 'registrando' 
  */

  // El array imageList siempre va a tener la lista de las imágenes que se suban
  // y en imageList[index].data_url tendrá el src del archivo

  const [images, setImages] = useState([]);
  const onChangeImages = (imageList) => {
      console.log(imageList);
      setImages(imageList);
  };

  return (
    <AgendarAsesoria 
      showAtrasBtn={true} 
      btnAtrasRoute="./AgendarAsesoriaUF" 
      btnSiguienteRoute="./AgendarAsesoriaCalendario"
      showTarjetaMaestraMini={true} 
      sizeTarjetaMaestraMini="normal" 
      progressBarJSON={progressBar}
    >
        <div className='container-aad'>
            <div className='top'>
                <h3>Explica tu duda:</h3>
                <CampoTextoGrande/>
            </div>
                
            <ImageUploading multiple value={images} onChange={onChangeImages} maxNumber={3} dataURLKey="data_url" acceptType={['jpg', 'png']}>
                {({ imageList, onImageUpload, onImageRemove }) => (
                <div className="container_ImageUploading">
                    <div className='container_imagenes'>
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
                        onClick={imageList.length === 3 ? () => alert('No se permite subir más de 3 imágenes') : onImageUpload} 
                        backgroundColor="gris" 
                        size="normal" 
                        Image={BiImageAdd} >
                            Subir imagen
                        </BotonConImagen>
                    </div>
                </div>
                )}
            </ImageUploading>

            <div>
                <button onClick={() => imageCompressor(images[0].data_url)}> imageCompressor </button>
            </div>
        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaDuda
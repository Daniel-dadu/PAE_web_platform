import React, { useState } from 'react'
import ImageUploading from "react-images-uploading";
import './AgendarAsesoriaDuda.css'

import { AgendarAsesoria, BotonConImagen, ImagenAsesoria, CampoTextoGrande } from '../../../routeIndex'

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

  // El array imageList siempre va a tener la lista de las imágenes que se suban
  // y en imageList[index].data_url tendrá el src del archivo

  const [images, setImages] = useState([]);
  const onChangeImages = (imageList) => {
      setImages(imageList);
  };

  const [dudaUser, setDudaUser] = useState('')

  const handleDuda = duda => {
    setDudaUser(duda)
  }

  return (
    <AgendarAsesoria 
      showAtrasBtn={true} 
      btnAtrasRoute="./AgendarAsesoriaUF/ok" 
      btnSiguienteProps={{view: 2, props: {duda: dudaUser, imagenes: images}}}
      showTarjetaMaestraMini={true} 
      sizeTarjetaMaestraMini="normal" 
      progressBarJSON={progressBar}
    >
        <div className='container-aad'>
            <div className='top'>
                <h3>Explica tu duda:</h3>
                <CampoTextoGrande parentCallback={handleDuda}/>
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

        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaDuda
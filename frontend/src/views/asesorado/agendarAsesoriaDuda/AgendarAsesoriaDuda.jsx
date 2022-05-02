import React from 'react'
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

    const [images, setImages] = React.useState([]);
    const onChange = (imageList, addUpdateIndex) => {
        // data for submit
        console.log(imageList, addUpdateIndex);
        setImages(imageList);
    };

  return (
    <AgendarAsesoria showAtrasBtn={true} showTarjetaMaestraMini={true} sizeTarjetaMaestraMini="normal" progressBarJSON={progressBar}>
        <div className='container-aad'>
            <h3>Explica tu duda</h3>
            <CampoTextoGrande/>
                
            <ImageUploading multiple value={images} onChange={onChange} maxNumber={3} dataURLKey="data_url">
                {({ imageList, onImageUpload, onImageRemove }) => (
                <div className="container_ImageUploading">
                    <div className='container_imagenes'>
                        {imageList.length === 0 ? 
                        <p>No se ha subido ninguna imagen</p>
                        : imageList.map((image, index) => (
                            <ImagenAsesoria
                                allowClosed = '1'
                                onClickX = {() => onImageRemove(index)}
                                size = 'normal'
                                source = {image.data_url}
                                alt = {`ImagenAsesoria${index}`}
                                nameDownloadImage = {`ImagenAsesoria${index}`}
                            />
                        ))}
                    </div>
                    <BotonConImagen onClick={onImageUpload} backgroundColor="gris" size="normal" Image={BiImageAdd} >
                        Subir imagen
                    </BotonConImagen>
                </div>
                )}
            </ImageUploading>

        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaDuda
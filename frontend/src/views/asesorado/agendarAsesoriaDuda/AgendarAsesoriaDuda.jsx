import React, { useState, useEffect } from 'react'
import ImageUploading from "react-images-uploading";
import { useNavigate } from "react-router-dom"

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

  const navigate = useNavigate();

  // Si se intenta ingresar a esta vista pero no se cuenta con el localStorage.asesoria_uf, se redirige al /agendarAsesoriaUF/ok
  useEffect(() => {
    if(!localStorage.asesoria_uf)
      navigate('/agendarAsesoriaUF/ok')
  }, [])

  // Revisando si hay una duda en el localStorage y cargándolas en caso de que sí
  // Esto es útil para cuando se regresa a esta vista con el botón 'atras'
  const [dudaUser, setDudaUser] = useState(localStorage.asesoria_duda ? localStorage.asesoria_duda : '')

  // Revisando si hay imágenes en el localStorage y cargándolas en caso de que sí
  // Esto es útil para cuando se regresa a esta vista con el botón 'atras'
  const [images, setImages] = useState(() => {
    if(localStorage.asesoria_imagen1){
      let previusImages = []
      previusImages.push({data_url: localStorage.asesoria_imagen1})
      if(localStorage.asesoria_imagen2) previusImages.push({data_url: localStorage.asesoria_imagen2})
      if(localStorage.asesoria_imagen3) previusImages.push({data_url: localStorage.asesoria_imagen3})
      return previusImages
    } 
    return []
  })

  const onChangeImages = imageList => {
    setImages(imageList);
  }

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
                <CampoTextoGrande parentCallback={handleDuda} defaultText={dudaUser}/>
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
              <button onClick={() => console.log(images)}>Console.log images array</button>
            </div>

        </div>
    </AgendarAsesoria>
  )
}

export default AgendarAsesoriaDuda
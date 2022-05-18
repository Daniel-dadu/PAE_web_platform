import React, { useState } from 'react'
import { useParams } from "react-router-dom"
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


  const resize = async (img, type) => {

    const MAX_SIZE = 50000 // 50kb
    const MIN_SIZE = 45000 // 45kb

    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')
    
    ctx.drawImage(img, 0, 0)
    
    let width = img.width
    let height = img.height
    let start = 0
    let end = 1
    let last, blob
    
    canvas.width = width
    canvas.height = height
    ctx.drawImage(img, 0, 0, width, height)
    
    blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, 1))
    
    if (blob.size < MAX_SIZE) return blob
    
    // Binary search for the right size
    while (true) {
        const mid = Math.round( ((start + end) / 2) * 100 ) / 100
        if (mid === last || (blob.size < MAX_SIZE && blob.size > MIN_SIZE)) break
        last = mid
        blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, mid))
        console.log(`Quality set to ${mid} gave a Blob size of ${blob.size} bytes`)
        if (blob.size > MAX_SIZE) end = mid 
        if (blob.size < MAX_SIZE) start = mid
    }

    return blob
  }

  const imageCompressor = (base64imageStr) => {
    
    let imageObject = new Image()
    imageObject.src = base64imageStr
    
    console.log('Converting image to webp\n')

    resize(imageObject, 'webp').then(blob => {
        console.log('Final blob size', blob.size)

        let reader = new FileReader();
        reader.readAsDataURL(blob); 
        reader.onloadend = () => {
            var base64data = reader.result;                
            console.log('----- Final result -----:', base64data);
            return base64data
        }
    })
}

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
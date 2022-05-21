import React, { useState } from 'react'

import { ImagenAsesoria, BotonConImagen } from '../../../routeIndex'

import './ImagenPerfilCambiar.css'

import ImageUploading from "react-images-uploading";
import { BiImageAdd } from 'react-icons/bi'
import noUserImg from '../../../assets/noUserImg.png'

function ImagenPerfilCambiar() {

    const [image, setImage] = useState(noUserImg);
    const onChange = (img) => setImage(img)

    return (
        <div>
            <ImageUploading value={image} onChange={onChange} maxNumber={1} dataURLKey="data_url">
                {({ imageUser, onImageUpload, onImageRemove }) => (
                <div className="container_ImageUploading_cambiar">
                    <div className='container_imagenes_RegistroAsesorado'>
                        {/* {imageList.length === 0 ?  */}
                        <img src={imageUser} alt="Sin imagen" />
                        {/* : imageList.map((image, index) => (
                            <ImagenAsesoria
                                allowClosed = '1'
                                onClickX = {() => onImageRemove(index)}
                                size = 'reducida'
                                source = {image.data_url}
                                alt = {`ImagenAsesoria${index}`}
                                nameDownloadImage = {`ImagenAsesoria${index}`}
                            />
                        ))} */}
                        <button onClick={() => onImageRemove()}>Eliminar foto</button>
                    </div>

                    <div className='btn_upload'>
                        <BotonConImagen 
                        // onClick={imageList.length === 1 ? () => alert('No se permite subir más de 1 imagen') : onImageUpload} 
                        onClick={onImageUpload} 
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
    )
}

export default ImagenPerfilCambiar
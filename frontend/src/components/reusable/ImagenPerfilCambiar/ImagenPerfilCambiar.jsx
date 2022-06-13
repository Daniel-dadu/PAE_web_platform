import React, { useState } from 'react'

import { BotonConImagen } from '../../../routeIndex'

import './ImagenPerfilCambiar.css'

import ImageUploading from "react-images-uploading";
import { BiImageAdd } from 'react-icons/bi'
import { TiDelete } from 'react-icons/ti'
import noUserImg from '../../../assets/noUserImg.png'
import noImage from '../../../assets/noImage.png'

function ImagenPerfilCambiar({ onUploadImage, previousImage=null, isImageEncuesta=false }) {

    const [image, setImage] = useState(previousImage ? [{data_url: previousImage}] : [])
    const onChange = (imageList) => {
        setImage(imageList)
        onUploadImage(imageList[0] ? imageList[0].data_url : null)
    }

    return (
        <ImageUploading value={image} onChange={onChange} maxNumber={1} dataURLKey="data_url">
            {({ imageList, onImageUpload, onImageUpdate, onImageRemove }) => (
            <div className="container_ImageUploading_cambiar">
                <div className='container_image_selected'>
                    { imageList.length === 0 ? 
                        <img 
                            src={isImageEncuesta ? noImage : noUserImg} 
                            alt="Foto subida" 
                            className={isImageEncuesta ? 'foto_evidencia_encuesta' : 'foto_subida_usuario'}
                        />
                        :
                        imageList.map((image, index) => (
                            <div key={index}>
                                <img 
                                    src={image.data_url} 
                                    alt="Foto subida" 
                                    className={isImageEncuesta ? 'foto_evidencia_encuesta' : 'foto_subida_usuario'}
                                />
                                <button 
                                    onClick={() => { onUploadImage(null); onImageRemove(index);}} 
                                    className={isImageEncuesta ? 'btn_delete_evidenciaImg' : 'btn_delete_userImg'}
                                >
                                        <TiDelete size={30}/>
                                </button>
                            </div>
                        ))
                    }
                </div>

                <div className='btn_upload'>
                    <BotonConImagen 
                        onClick={imageList.length === 0 ? onImageUpload : () => onImageUpdate(0)} 
                        backgroundColor="turquesa" 
                        size="reducido" 
                        Image={BiImageAdd} 
                    >
                        {imageList.length === 0 ? "Subir imagen" : "Cambiar imagen"}
                    </BotonConImagen>
                </div>
            </div>
            )}
        </ImageUploading>
    )
}

export default ImagenPerfilCambiar
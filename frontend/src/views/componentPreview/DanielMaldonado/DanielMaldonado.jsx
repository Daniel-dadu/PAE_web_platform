import React, { useState } from 'react'
import './DanielMaldonado.css'

import axios from 'axios'
import ImageUploading from "react-images-uploading";

import { Template, ImagenAsesoria, BotonConImagen } from '../../../routeIndex'

import { BiImageAdd } from 'react-icons/bi'

function DanielMaldonado() {

  const [images, setImages] = useState([]);
  const onChangeImages = (imageList) => {
      console.log(imageList);
      setImages(imageList);
  };

  const [matricula, setMatricula] = useState("");

  const [imagenPerfil, setImagenPerfil] = useState("");

  const updateFoto = () => {    
    var config = {
      method: 'put',
      url: 'http://20.225.209.57:3090/registro/prueba_foto',
      headers: { 
        'Content-Type': 'application/json'
      },
      data: JSON.stringify({
        "matricula": matricula,
        "fotoPerfil": images[0].data_url
      })
    };
    
    axios(config)
    .then(function (response) {
      console.log(response.data);
    })
    .catch(function (error) {
      console.log(error);
    });
  }

  const getFoto = () => {
    var config = {
      method: 'get',
      url: 'http://20.225.209.57:3090/registro/prueba_get_foto?matricula=A01657967',
      headers: { },
      data: '' 
    };
    
    axios(config)
    .then(function (response) {
      console.log(response.data.fotoPerfil);
      setImagenPerfil(response.data.fotoPerfil);
    })
    .catch(function (error) {
      console.log(error);
    });
  }

  return (
    <div>
      <Template view="perfil">
        <h1>PRUEBA PARA SUBIR UNA IMAGEN EN BASE64 A LA BASE DE DATOS</h1>
        <h2>Esta prueba sube la imagen de perfil de un usuario, pero se debe indicar su matrícula en el campo de texto</h2>

        <div className='dadu_matricula_container'>
          Matricula: 
          <input className='dadu_input' type="email" id="exampleInputEmail1" aria-describedby="emailHelp" onChange={({ target }) => setMatricula(target.value)}/>
          Resultado: {matricula}
        </div>

        <div>
          <ImageUploading multiple value={images} onChange={onChangeImages} maxNumber={1} dataURLKey="data_url" acceptType={['jpg', 'png']}>
                {({ imageList, onImageUpload, onImageRemove }) => (
                <div className="container_ImageUploading1">
                    <div className='container_imagenes1'>
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

        <div>
          <button onClick={updateFoto}>Subir imagen</button>
        </div>

        <div>
          <button onClick={getFoto}>Mostrar imagen</button>
          <br />
          <img src={imagenPerfil} alt="" />
        </div>
      </Template>
    </div>
  )
}

export default DanielMaldonado
import React, { useState } from 'react'
import './DanielMaldonado.css'

import axios from 'axios'
import ImageUploading from "react-images-uploading";

import { Template, ImagenAsesoria, BotonConImagen, imageCompressor, PopUpEncuesta, Modal } from '../../../routeIndex'

import { BiImageAdd } from 'react-icons/bi'

import useScript from '../../../hooks/useScript.js';

function DanielMaldonado() {

  useScript('https://smtpjs.com/v3/smtp.js')


  const [images, setImages] = useState([]);
  const onChangeImages = (imageList) => {
      console.log(imageList);
      setImages(imageList);
  };

  const [matricula, setMatricula] = useState("");

  const [imagenPerfil, setImagenPerfil] = useState("");

  const updateFoto = async () => {    
    let imageCompressed = await imageCompressor(images[0].data_url, 5000)

    console.log('----- Final result -----:', imageCompressed); // __________ ¡¡¡¡¡¡¡QUITAAAAAR!!!!!!! __________

    var config = {
      method: 'put',
      url: 'http://20.225.209.57:3090/registro/prueba_foto',
      headers: { 
        'Content-Type': 'application/json'
      },
      data: JSON.stringify({
        "matricula": matricula,
        "fotoPerfil": imageCompressed
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
      url: 'http://20.225.209.57:3090/registro/prueba_get_foto?matricula=' + matricula,
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

  const btnStyle = {fontSize: 20, cursor: 'pointer', padding: 5, borderRadius: 10, backgroundColor: 'grey', color: 'white'}


  // ========== PARA ENCUESTA =========== //
  const [activoEncuesta, setActivoEncuesta] = useState(false)
  const cerrarEncuesta = () => setActivoEncuesta(!activoEncuesta)
  // ========== PARA ENCUESTA =========== //


  // Prueba de correos:

  const sendEmail = () => {
    window.Email.send({
        SecureToken : "d852b9c0-032f-44da-a2b3-6769984428b2",
        To : 'dadu9494@gmail.com',
        From : "paetecpuebla@gmail.com",
        Subject : "Mira este super correo",
        Body : "Yo creo que esto te gusta"
    }).then(
        message => alert(message)
    ); 
  }

  return (
    <div>
      <Template view="perfil">

        <button className='btn_show_encuesta_dadu' onClick={cerrarEncuesta} >MOSTRAR ENCUESTA DE PRUEBA</button>
        <button className='btn_show_encuesta_dadu' onClick={sendEmail} >Mandar correo</button>

        <Modal active = {activoEncuesta} toggle = {cerrarEncuesta}>
          <PopUpEncuesta 
            tipo={2} 
            idAsesoria={93} // Esto debe obtenerse del número de la asesoría al que corresponde
            activo={activoEncuesta} 
            ocultarPopUp={cerrarEncuesta} 
          />
        </Modal>

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

        <br />
        
        <div>
          <h3>Primero se debe seleccionar una imagen en la parte de arriba y luego darle click al botón de "Subir imagen de {matricula} a API"</h3>
          <button onClick={updateFoto} style={btnStyle}>Subir imagen de {matricula} a API</button>
        </div>

        <br />
        <br />

        <div>
          <h3>De click al botón de "Mostrar imagen" para mostrar la imagen de {matricula}</h3>
          <p>El botón solo funciona después de que se subió la imagen a la API</p>
          <button onClick={getFoto} style={btnStyle}>Mostrar imagen</button>
          <br />
          <br />
          <img src={imagenPerfil} alt="" style={{width: '100%'}} />
        </div>
      </Template>
    </div>
  )
}

export default DanielMaldonado
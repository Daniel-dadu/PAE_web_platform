import React, {useState} from 'react'
import { useNavigate } from 'react-router-dom'

import './RegistroDirectivo.css'
import axios from 'axios'

import { Template, CampoTextoPequeno, ImagenPerfilCambiar, BotonSencillo, imageCompressor } from '../../../routeIndex.js'
import LoadingSpin from "react-loading-spin"

function RegistroDirectivo() {

    const navigate = useNavigate()

    const [loadingNext, setLoadingNext] = useState(false)

    const [matricula, setMatricula] = useState('')
    const handleTextMatricula = textInserted => setMatricula(textInserted)
    
    const [contrasena, setContrasena] = useState('')
    const handleTextContrasena = textInserted => setContrasena(textInserted)
    const [contrasenaConfirm, setContrasenaConfirm] = useState('')
    const handleTextContrasenaConfirm = textInserted => setContrasenaConfirm(textInserted)

    const [nombre, setNombre] = useState('')
    const handleTextNombre = textInserted => setNombre(textInserted)

    const [apellidoParterno, setApellidoParterno] = useState('')
    const handleTextApellidoParterno = textInserted => setApellidoParterno(textInserted)

    const [apellidoMarterno, setApellidoMarterno] = useState('')
    const handleTextApellidoMarterno = textInserted => setApellidoMarterno(textInserted)

    const [telefono, setTelefono] = useState('')
    const handleTextTelefono = textInserted => setTelefono(textInserted)

    const [imageUploaded, setImageUploaded] = useState(null)
    const onHandleUploadImage = image => setImageUploaded(image)
    
    const crearDirectivo = async () => {
        if(matricula.length < 9) alert("La matrícula debe tener 9 caracteres")
        else if(contrasena.length < 8) alert("La contraseña debe tener al menos 8 caracteres")
        else if(contrasena !== contrasenaConfirm) alert("Las contraseñas no coinciden")
        else if(nombre === '') alert("El nombre es un campo obligatorio")
        else if(apellidoParterno === '') alert("El apellido parterno es un campo obligatorio")
        else {

            setLoadingNext(true)

            const imageCompressed = await imageCompressor(imageUploaded)
            if(imageCompressed.slice(0, 5) === "error"){
                alert('Tu imagen de perfil es muy grande.\nReduce el tamaño y vuelve a intentarlo')
                setLoadingNext(false)
                return
            }
            
            const config = {
                method: 'post',
                url: 'http://20.225.209.57:3090/registro/nuevo_directivo/',
                headers: { 
                    'Content-Type': 'application/json'
                },
                data: JSON.stringify({
                    "matricula": matricula,
                    "contrasena": contrasena,
                    "nombre": nombre,
                    "apellidoPaterno": apellidoParterno,
                    "apellidoMaterno": apellidoMarterno,
                    "fotoPerfil": imageCompressed,
                    "telefono": telefono
                })
            }
            
            axios(config)
            .then(response => {
                alert(response.data)
                navigate('/administrarDirectivos')
            })
            .catch(error => {
                alert("Error: " + error.response.data)
            })
        }

        setLoadingNext(false)
    }

    return (
        <Template view = "administrar">
            <div className='contener_DatosAsesoradoInputRegistro'> 

                <h2>Registro de directivo</h2>

                <div className='contenedro_deInputsAsesoradoRegistro_credenciales'>
                    <p align='center' style={{fontStyle: 'italic'}}>Credenciales para el acceso a la plataforma</p>

                    <div className='contenedro_deInputsAsesoradoRegistro'> 
                        <div className='texto_contenedor_deInputsAsesoradoRegistro'> 
                            Matrícula o Nómina *
                            { matricula.length < 9 && <span className='input_incorrecto'>La matrícula debe tener 9 caracteres</span> }
                        </div>
                        <CampoTextoPequeno maxNumCaracteres="9" size="big" onInsertText={handleTextMatricula} />
                    </div>

                    <div className='contenedro_deInputsAsesoradoRegistro'> 
                        <div className='texto_contenedor_deInputsAsesoradoRegistro'> 
                            Contraseña *
                            { contrasena.length < 8 && <span className='input_incorrecto'>La contraseña debe tener al menos 8 caracteres</span> } 
                        </div>
                        <CampoTextoPequeno size="big" onInsertText={handleTextContrasena} isPassword={true}/>
                    </div>

                    <div className='contenedro_deInputsAsesoradoRegistro'> 
                        <div className='texto_contenedor_deInputsAsesoradoRegistro'> 
                            Confirmar contraseña * 
                            { contrasena !== contrasenaConfirm && <span className='input_incorrecto'>Las contraseñas no coinciden</span> } 
                        </div>
                        <CampoTextoPequeno size="big" onInsertText={handleTextContrasenaConfirm} isPassword={true} />
                    </div>

                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Nombre(s) * </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextNombre} />
                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Paterno * </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextApellidoParterno} />
                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Apellido Materno </div>
                    <CampoTextoPequeno size="big" onInsertText={handleTextApellidoMarterno} />
                </div>

                <div className='contenedro_deInputsAsesoradoRegistro'> 
                    <div className='texto_contenedor_deInputsAsesoradoRegistro'> Número de teléfono </div>
                    <CampoTextoPequeno maxNumCaracteres="10" size="big" onInsertText={handleTextTelefono} />
                </div>

                <div className='contenedor_imagenPerfil'> 
                    <p className='texto_contenedor_deInputsAsesoradoRegistro title_imagenPerfil'> Imagen de Perfil </p>
                    <ImagenPerfilCambiar onUploadImage={onHandleUploadImage} />
                </div>

                <br />

                {
                    loadingNext ?
                    <div className='loading_spin'>
                        <LoadingSpin />
                    </div>
                    :
                    <div className='btns_registrar_cancelar_directivo'>
                        <BotonSencillo onClick={ crearDirectivo } backgroundColor='verde' children="Confirmar registro" />
                        <BotonSencillo onClick={ () => navigate('/administrarDirectivos') } backgroundColor='rojo' children="Cancelar registro" />
                    </div>
                }

            </div>
        </Template>
    )
}

export default RegistroDirectivo
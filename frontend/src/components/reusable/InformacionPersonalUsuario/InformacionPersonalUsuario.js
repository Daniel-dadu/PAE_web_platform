import React, { useState } from 'react';
import { FaPen } from "react-icons/fa";
import { BiImageAdd } from 'react-icons/bi';
import { CampoSeleccionarEnListaDesplegable, 
    CampoTextoPequeno, 
    BotonSencillo, 
    ImagenAsesoria,BotonConImagen } from '../../../routeIndex';
import './informacionPersonalUsuario.css';
import data from './data.json';
import ImageUploading from "react-images-uploading";

/*
    DOCUMENTACION PARA USO DEL COMPONENTE
    Notas importantes: 

        -> el componente InformacionPersonalUsuario no recibe properties.
        -> Es importante que se maneje un json como se muestra en el ejemplo, y siempre especificar que tipo de usuario es
            en el archivo json en parametro tipoUsuario, este podra tener el valor 1 o 2, en donde:
                1 == tipo de usuario asesor o asesorado
                2 == directivo
        ->En el documento json se debera tener en cuenta que el valor camposVariantes, pueden variar, es decir, allí iran los datos que 
            la consulta de la base de datos extraiga.

    json explicacion:
        -> se divide de esta manera :
            "tipoUsuario" => corresponde a que tipo de usuario sera usado el componente
            "relleno" => correpsonde a los campos que debe llenar cada dropdownlist que para modificar información
            "informacion" => corresponde a los datos de los datos extraidos de la consulta a la base de datos
                        "camposObligatorios" => siempre apareceran en las vistas finales
                        "camposVariables" => podrán variar segun la informacion obtenida de la BD y del tipo de usuario
*/ 

const InformacionPersonalUsuario = () => {

    //usados para el cambio de imagen
    const [editar, setEditar] = useState(false);
    const [previewImage, setPreviewImage] = useState([]);
    const onChange = (imageList) => {
        setPreviewImage(imageList);
        console.log(imageList);
   };

   // usado para alternar entre editar y visualizacion de los datos
    const handleEditarPerfil = () => {
        setEditar(!editar);
    }

    //función para armar cadena del campo cadenas, retorna un String armado
    const armarCadenaCarrea = (carreras) => {
        let cadena ="";
        for( let i = 0; i<carreras.length ; i++ ){
            if( i === carreras.length - 1 )
                cadena += carreras[i];
            else
            cadena += carreras[i] + ', ';

        }

        return cadena;
    }


  return (
    <>
        <div className='contenedor-general-InfPerUsuario'>

            {   
                // usando la variable editar, podremos alternar entre modificar datos y editar datos
                !editar ?
                (

                    <div className='contenedor-InfPerUsuario'>

                        <div className='contenedor-InfPerUsuario-izq' >

                            <div className='contenedor-img-perfil-InfPerUsuario'>

                                <img src={ require( `../../../assets/img-editar-perfil-tmp.JPG` ) } alt="imgProfile" className='imagen-InfPerUsuario'/>
                                <button className='btn-editar-InfPerUsuario' onClick={ handleEditarPerfil }>
                                    <div className='contenedor-btn-editar-InfPerUsuario'>
                                        <p className='btn-texto-InfPerUsuario'>Editar</p>
                                        <FaPen/>
                                    </div>
                                </button>

                            </div>

                        </div>

                        <div className='contenedor-InfPerUsuario-der' >
                            
                            <p className='etiqueta-nombre-InfPerUsuario' >{ data["informacion"].camposObligatorios[0].info }</p>
                            <p className='etiqueta-matricula-InfPerUsuario' >{ data["informacion"].camposObligatorios[1].info }</p>

                            {
                            // iteramos con map entre los camposVariantes que tenemos en el archivo json
                            data["informacion"].camposVariantes.map((campos) => (
                                
                                <p className={ `etiqueta-${campos.nombreClase}-InfPerUsuario` }  >

                                    { 
                                        //condicional para arreglar cadena de carreras
                                        ( campos.campo === "Carrera(s)" ?
                                            (campos.info.length === 1 ? 
                                                `${ campos.campo }: ${ campos.info[0]}`
                                                : 
                                                `${campos.campo}: ${ armarCadenaCarrea(campos.info) }`  )
                                            : 
                                            `${campos.campo}: ${campos.info}`
                                        )  
                                    }

                                </p>
                            )) 
                            }

                        </div>

                    </div>
                )
                :
                (

                    <div className='contenedor-InfPerUsuario'>

                        <div className='contenedor-InfPerUsuario-izq-actualizar-img' >
                            
                            {/* Aqui es donde podemos modificar la imagen de perfil */}
                            <ImageUploading multiple value={previewImage} onChange={onChange} maxNumber={1} dataURLKey="data_url">
                                {
                                    ({ imageList, onImageUpload, onImageRemove }) => (

                                        <div className="container_ImageUploading_RegistroAsesor">

                                            <div className='container_imagenes_RegistroAsesor'>
                                                {
                                                    //si no hay imagenes guardadas ponemos la imagen actual
                                                    imageList.length === 0 ? 
                                                    <img 
                                                        src={ require( `../../../assets/img-editar-perfil-tmp.JPG` ) } 
                                                        alt="imgProfile" 
                                                        className='imagen-InfPerUsuario-actualizar-img'
                                                    />
                                                    
                                                    : //de otro modo, iteramos el arreglo de imagenes y usamos el componente de ImagenAsesoria 
                                                    imageList.map((image, index) => (
                                                        <ImagenAsesoria
                                                            allowClosed = '1'
                                                            onClickX = {() => onImageRemove(index)}
                                                            size = 'reducida'
                                                            source = {image.data_url}
                                                            alt = {`ImagenAsesoria${index}`}
                                                            nameDownloadImage = {`ImagenAsesoria${index}`}
                                                        />
                                                    ))
                                                }
                                            </div>
                                            <div className='btn_upload'>
                                                <BotonConImagen 
                                                    onClick={imageList.length === 1 ? () => alert('No se permite subir más de 1 imagen') : onImageUpload} 
                                                    backgroundColor="azulCielo" 
                                                    size="largo" 
                                                    Image={BiImageAdd} 
                                                >
                                                    Subir imagen
                                                </BotonConImagen>

                                            </div>

                                        </div>
                                )}
                            </ImageUploading>

                        </div>

                        
                        
                        <div className='contenedor-InfPerUsuario-der' >
                            
                             <p className='etiqueta-nombre-InfPerUsuario' >{ data["informacion"].camposObligatorios[0].info }</p>
                             <p className='etiqueta-matricula-InfPerUsuario-2' >{ data["informacion"].camposObligatorios[1].info }</p>
                             
                             {
                                 // si el usuario asesor o asesorado, se mostraran todos los campos
                                 data["tipoUsuario"] === 1 ?
                                 (
                                     <div>
                                        <p className='etiqueta-carrera-InfPerUsuario' > Carrera: </p><CampoSeleccionarEnListaDesplegable size="big"  idList="carrera" options={ data.relleno.carrera } />
                                        <p className='etiqueta-carrera-InfPerUsuario' > Carrera 2: </p><CampoSeleccionarEnListaDesplegable size="big"  idList="carrera" options={ data.relleno.carrera } />
                                        <p className='etiqueta-semestre-InfPerUsuario'> Semestre: </p><CampoSeleccionarEnListaDesplegable size="small" idList="semestre" options={ data.relleno.semestre} />
                                        <p className='etiqueta-telefono-InfPerUsuario'> Telefono </p><CampoTextoPequeno size="medium"/>
                                     </div>
                                 )
                                 : // si es diractivo, solo podra modificar el numero telefonico
                                 (
                                     <div>
                                         <p className='etiqueta-telefono-InfPerUsuario'> Telefono </p><CampoTextoPequeno size="medium"/>
                                     </div>
                                 )
 
                             }
                             
                            {/* Contenedor de botones de cancelar y guardar */}
                             <div className='contenedor-btn-editar'>
 
                                 <BotonSencillo  onClick={ handleEditarPerfil } backgroundColor="gris" size="normal" children="Cancelar" />
                                 <BotonSencillo  onClick={ handleEditarPerfil } backgroundColor="verde" size="normal" children="Confirmar" />
 
                             </div>
 
                         </div>
                        
                    </div>

                )
            }


        </div>
    </>
  )
}

export default InformacionPersonalUsuario
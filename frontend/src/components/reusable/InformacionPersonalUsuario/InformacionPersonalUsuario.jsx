import React, { useState, useEffect } from 'react';
import { FaPen } from "react-icons/fa";
import axios from 'axios';

import { CampoSeleccionarEnListaDesplegable, CampoTextoPequeno, BotonSencillo, ImagenPerfilCambiar } from '../../../routeIndex';

import noUserImg from '../../../assets/noUserImg.png'

import './informacionPersonalUsuario.css';

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

    // Hook para guardar la lista de carreras
    const [listaCarreras, setListaCarreras] = useState(['Cargando...'])

    // Obtenemos la lista de carreras de la API
    useEffect(() => {
        const config = {
            method: 'get',
            url: 'http://20.225.209.57:3091/general/get_carreras',
            headers: { }
        };
        
        axios(config)
        .then(response => {
            const carreras = response.data.map(carrera => carrera.idCarrera + ' - ' + carrera.nombreCarrera)
            setListaCarreras(carreras)
        })
        .catch(_error => {
            alert("ERROR: No se pudieron obtener las carreras")
        })

    }, [setListaCarreras])

    const rolUsr = localStorage.rolUsuario
    // const rolUsr = 'directivo'

    let data = {   
        "tipoUsuario" : rolUsr === "directivo" ? 2 : 1,
    
        "relleno": {
            "carrera": listaCarreras,
            "semestre": [1,2,3,4,5,6,7,8,9]
        },
        "informacion": {
            "camposObligatorios": [
                {
                    "campo": "Nombre",
                    "info": "Mario Alonso",
                    "nombreClase": "nombre"
                },
                {
                    "campo": "Matricula",
                    "info": "A01734184",
                    "nombreClase": "matricula"   
                }
            ],
            "camposVariantes": [
                {
                    "campo": "Carrera(s)",
                    "info": ["ITC","IRS"],
                    "nombreClase": "carrera" 
                },
                {
                    "campo": "Telefono",
                    "info": 222777888,
                    "nombreClase":"telefono"
                }
            ]
        }
        
    }

    if (rolUsr === 'asesor') {
        data.informacion.camposVariantes.push({
            "campo": "Semestre",
            "info": 1,
            "nombreClase": "semestre"  
        })
    }

    //usados para el cambio de imagen
    const [editar, setEditar] = useState(false);

    const [imagenPerfil, setImagenPerfil] = useState(localStorage.fotoUsuario)

    const onHandleUploadImage = image => setImagenPerfil(image)

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

                                <img src={ imagenPerfil ? imagenPerfil : noUserImg } alt="imgProfile" className='imagen-InfPerUsuario'/>
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

                                    { rolUsr !== 'directivo' &&
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
                          <ImagenPerfilCambiar onUploadImage={onHandleUploadImage} previousImage={imagenPerfil}/>
                        </div>
                        
                        <div className='contenedor-InfPerUsuario-der' >
                            
                             <p className='etiqueta-nombre-InfPerUsuario' >{ data["informacion"].camposObligatorios[0].info }</p>
                             <p className='etiqueta-matricula-InfPerUsuario-2' >{ data["informacion"].camposObligatorios[1].info }</p>
                             
                             {
                                 // si el usuario asesor o asesorado, se mostraran todos los campos
                                data["tipoUsuario"] === 1 ?
                                <div>
                                    <p className='etiqueta-carrera-InfPerUsuario' > Carrera: </p>
                                    <CampoSeleccionarEnListaDesplegable size="big"  idList="carrera" options={ data.relleno.carrera } />
                                    
                                    <p className='etiqueta-carrera-InfPerUsuario' > Carrera 2: </p>
                                    <CampoSeleccionarEnListaDesplegable size="big"  idList="carrera" options={ data.relleno.carrera } />

                                    { // Si es un asesor, se muestra el campo para cambiar el semestre
                                        rolUsr === 'asesor' && 
                                        <div>
                                            <p className='etiqueta-semestre-InfPerUsuario'> Semestre: </p>
                                            <CampoSeleccionarEnListaDesplegable size="small" idList="semestre" options={data.relleno.semestre} />
                                        </div>
                                    }

                                    <p className='etiqueta-telefono-InfPerUsuario'> Telefono </p>
                                    <CampoTextoPequeno size="medium"/>
                                </div>
                                : // si es diractivo, solo podra modificar el numero telefonico
                                <div>
                                    <p className='etiqueta-telefono-InfPerUsuario'> Telefono </p>
                                    <CampoTextoPequeno size="medium"/>
                                </div>
 
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
import React from 'react'

import { TemplateRegistroUsuario, CampoTextoPequeno, ImagenAsesoria, CampoSeleccionarEnListaDesplegable, BotonConImagen } from '../../../routeIndex'

import data from './data.json';


let progressBar = {
    "currentStep": 0,
    "steps": [
        {
            "name" : "Datos Generales",
            "state": null,
            "next": "enable",
            "path" : "/registroAsesoradoDatos"
          }, 
          {
            "name" : "Consideraciones Finales",
            "state": null,
            "next": "enable",
            "path" : "./registroAsesoradoCondiciones"
          },
          {
            "name" : "Confirmación",
            "state": null,
            "next": "enable",
            "path" : "Ruta"
          }
    ]
}

const RegistroAsesoradoResumen = () => {

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
    
        <TemplateRegistroUsuario 
            progressBarJSON={progressBar}
            btnAtrasRoute ="./registroAsesoradoCondiciones"
            ultimoTexto='Confirmar'>
            
            <div className='bloq_condicionesAsesorado'>
                <h1 className='campo_RegistroAsesoradoCondiciones'> Resumen de información </h1>
     
            </div>
            <div className='contenedor-general-InfPerUsuario'>
                <div className='contenedor-InfPerUsuario'>

                    <div className='contenedor-InfPerUsuario-izq' >

                        <div className='contenedor-img-perfil-InfPerUsuario'>

                            <img src={ require( `../../../assets/img-editar-perfil-tmp.JPG` ) } alt="imgProfile" className='imagen-InfPerUsuario'/>
                            

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
            </div>
        </TemplateRegistroUsuario>
        
        </>
  )
}

export default RegistroAsesoradoResumen
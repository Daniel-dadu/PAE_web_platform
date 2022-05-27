import React, { useRef } from 'react'
import './listaUnidadesDeFormacionAsesor.css'
import { TarjetaListaDesplegable } from '../../../routeIndex';
import { useIsOverflowX } from '../../../hooks/useIsOverflowX';

const dataExample = [
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:1
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:1
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:2
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:2
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        }
    },
    {
        t1 : {
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        },
        t2:{
            claveUF:"TC3005B",
            nombreUF:"Desarrollo de software",
            semestre:3
        }
    }
  
]


const ListaUnidadesDeFormacionAsesor = ({ data= dataExample }) => {
    
    /*
        DOCUMENTACION DEL COMPONENTE
        
        Notas importantes: 
            -> para el uso del componente, se requiere de informacion traida desde la base de datos, o desde la vista o el 
            componente padre donde se este invocando el componente ListaUnidadesDeFormacionAsesor.
            -> La informacion recibida, debera ser exactamente igual al ejemplo que se muestra en el objeto definido en dataExample.
            -> Se hace uso de un custom Hook, para poder detectar el overflowing de un div
        
        Uso:
            -> propiedades:

                ->data:  para hacer uso del componente, solo se requiere pasar a traves de las propiedades, un objeto con las siguientes caracteristicas:
                    Ejemplo de formato del objeto a recibir    
                        ========================
                        [
                            {  --> cada bracket representa una nueva fila, y en cada fila van dos tarjetas de unidades de formacion<--
                                t1: {
                                    claveUF:"TC3005B", --> clave en string de la UF <--
                                    nombreUF:"Desarrollo de software", --> nombre en string de la UF <--
                                    semestre:3 --> semestre de la UF como entero <--
                                }
                            },
                            {
                                t2: {
                                    claveUF:"TC3005B",
                                    nombreUF:"Desarrollo de software",
                                    semestre:3
                                }
                            }
                        ]
                        ========================
        Ejemplo de uso:
          <ListaUnidadesDeFormacionAsesor data={ unidadesDeFormacion }/> 

    */  
    

    // usamos el custom hook, le mandamos la referencia del elemento 
    const ref = useRef();
    const isOverflow = useIsOverflowX(ref);





  return (
        <>
            <div className='contendor-general-ludfa'>
                <div className='contenedor-ludfa'>

                    
                    <div className='encabezado-ludfa'>
                        <h3 className='texto-encabezado-ludfa'> Unidades de formación en las que doy asesoría: </h3>
                    </div>
                    <div className='contenido-ludfa'>
                        <table className='tabla-contenido-ludfa' ref={ref}>
                            
                            {
                                isOverflow?
                                (
                                    <tr className='fila-tabla-contenido-ludfa'></tr>
                                ):
                                (
                                    <></>
                                )
                            }
                            {
                                data.map((fila) => (
                                    

                                    <tr className='fila-tabla-contenido-ludfa'>
                                        <td className='celda-tabla-contenido-ludfa'>
                                            <TarjetaListaDesplegable 
                                                tipo={ 4 } 
                                                claveUF={ fila.t1.claveUF }  
                                                nombreUF={ fila.t1.nombreUF }  
                                                semestre={ fila.t1.semestre } 
                                            />
                                            
                                        </td>
                                        <td className='celda-tabla-contenido-ludfa'>
                                            <TarjetaListaDesplegable 
                                                tipo={ 4 } 
                                                claveUF={ fila.t2.claveUF }  
                                                nombreUF={ fila.t2.nombreUF }  
                                                semestre={ fila.t2.semestre } 
                                            />
                                        </td>
                                    </tr>
                                ))
                            }
                        
                        </table>
                    </div>
                </div>
            </div>
        </>
  )
}

export default ListaUnidadesDeFormacionAsesor
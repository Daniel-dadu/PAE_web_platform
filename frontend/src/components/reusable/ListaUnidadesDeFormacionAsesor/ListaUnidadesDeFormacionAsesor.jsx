import React from 'react'
import './listaUnidadesDeFormacionAsesor.css'
import { TarjetaListaDesplegable } from '../../../routeIndex';

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
                        { 
                            claveUF:"TC3005B", --> clave en string de la UF <--
                            nombreUF:"Desarrollo de software", --> nombre en string de la UF <--
                            semestre:3 --> semestre de la UF como entero <--
                        },
                        {
                            claveUF:"TC3005B",
                            nombreUF:"Desarrollo de software",
                            semestre:3
                        }
                    ]
                    ========================
    Ejemplo de uso:
      <ListaUnidadesDeFormacionAsesor data={ unidadesDeFormacion }/> 

*/  

const ListaUnidadesDeFormacionAsesor = ({ data }) => {
    
    return (
        <div className='contendor-general-ludfa'>
            <h3 className='texto-encabezado-ludfa'> Unidades de formación en las que doy asesoría: </h3>
            <div className='contenido-ludfa'>
                {
                    data.map((fila, index) => 
                        <TarjetaListaDesplegable 
                            tipo={ 4 } 
                            claveUF={ fila.claveUF }  
                            nombreUF={ fila.nombreUF }  
                            semestre={ fila.semestre } 
                            key={index}
                        />
                    )
                }
            </div>
        </div>
    )
}

export default ListaUnidadesDeFormacionAsesor
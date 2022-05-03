import React from 'react'
import "./TarjetaInformacion.css"

function TarjetaInformacion(props){ 
    /*
    El componente recibe 1 solo valor de tipo json con una lista con los datos 
    categoria-descripcion, esta conformado por:
        -title: titulo al cual pertenece los datos.
        -info: es un string con la informacion.

            Ejemplo:
                {
                    "info": [
                        {
                            "title": "titulo",
                            "info": "info"
                        },
                        ....
                    ]
                }
    
    Ejemplo:
        info={info}
    */

    return(
        <div className='tarjeta_informacion_container'>
            {props.info.info.map((data) => {
                    return (
                        <div>
                            <div className='tarjeta_informacion_titulo'>{data.title}</div>
                            <div className='tarjeta_informacion_info'>{data.info}</div>
                        </div>
                    )
                })}
        </div>
    )   
}
export default TarjetaInformacion
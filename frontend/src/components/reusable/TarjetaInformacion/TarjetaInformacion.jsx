import React from 'react'
import "./TarjetaInformacion.css"

function TarjetaInformacion({info}){ 
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
            {info.map((data, index) => {
                return (
                    data.title === "Fotos" ?
                        <div className='tarjeta_informacion_titulo_info_container' key={index}>
                            <div className='tarjeta_informacion_titulo'>{data.title}</div>
                            <div className='tarjeta_informacion_info_images'>
                                {
                                    data.info[0] ? 
                                    data.info.map((img, i) => {
                                        return img ? <img src={img} alt={i} key={i} /> : null
                                    }) 
                                    :
                                    "No se ingresaron imágenes"
                                }
                            </div>
                        </div>
                    :
                        <div className='tarjeta_informacion_titulo_info_container' key={index}>
                            <div className='tarjeta_informacion_titulo'>{data.title}</div>
                            <div className='tarjeta_informacion_info'>{data.info}</div>
                        </div>
                )
                })}
        </div>
    )   
}
export default TarjetaInformacion
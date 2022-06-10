import React from "react";

import "./PreguntaCerradaEncuesta.css";


// eslint-disable-next-line no-lone-blocks
{/* <PreguntaCerradaEncuesta

preguntaCerrada={'Aqui pon la pregunta que quieres que salga'}>

</PreguntaCerradaEncuesta> */}


function PreguntaCerradaEncuesta({ preguntaCerrada, opciones = [20, 30, 40, 45, "más de 45"], indexPregunta, respuesta = 0 }) {
    return (
        <div className="contenedorPreguntaCerradaEncuesta">
            <div className="textoPreguntaCerradaEncuesta"> {preguntaCerrada} </div>

            <div>

                {
                    [1,2,3,4,5,6,7,8,9,10].map(opcion => 
                        <label for="contactChoice1">
                            {
                                respuesta === 1 ?
                                (

                                <input type="radio" id={"cal"+opcion} name={ `Calificacion${indexPregunta}`} value={opcion} checked={true}/>
                                ):
                                (
                                <input type="radio" id={"cal"+opcion} name={ `Calificacion${indexPregunta}`} value={opcion}  />
                                )
                            }
                            <span
                                style={{
                                position: "relative",
                                left: "-24px",
                                top: "-22px",
                                fontSize: "20px"
                                }}
                            >
                                {opcion}
                            </span>
                        </label>

                    )

                }
        
            </div>
        </div>
    );
}

export default PreguntaCerradaEncuesta;
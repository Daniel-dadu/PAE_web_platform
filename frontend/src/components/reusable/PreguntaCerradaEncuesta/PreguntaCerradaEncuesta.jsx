import React, { useState } from "react";

import "./PreguntaCerradaEncuesta.css";


// eslint-disable-next-line no-lone-blocks
{/* <PreguntaCerradaEncuesta

preguntaCerrada={'Aqui pon la pregunta que quieres que salga'}>

</PreguntaCerradaEncuesta> */}


function PreguntaCerradaEncuesta({ preguntaCerrada, opciones=[1,2,3,4,5], indexPregunta, getOptionSelected }) {

    const [selectedOption, setSelectedOption] = useState(null)
    
    const selectOption = option => {
        setSelectedOption(option)
        getOptionSelected(option, indexPregunta)
    } 

    return (
        <div className="contenedorPreguntaCerradaEncuesta">
            <div className="textoPreguntaCerradaEncuesta"> {preguntaCerrada} </div>

            <div className="contenedorOpciones">
                {
                    opciones.map((opcion, index) => 
                        <button key={index} onClick={() => selectOption(index)} style={{
                            backgroundColor: selectedOption === index ? "#1624DA" : "#E5E5E5",
                            color: selectedOption === index ? "white" : "black"
                        }}>
                            {opcion}
                        </button>
                    )
                }
            </div>
        </div>
    );
}

export default PreguntaCerradaEncuesta;
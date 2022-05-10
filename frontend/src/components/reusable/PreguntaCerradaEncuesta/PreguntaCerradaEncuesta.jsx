import React from "react";

import "./PreguntaCerradaEncuesta.css";


// eslint-disable-next-line no-lone-blocks
{/* <PreguntaCerradaEncuesta

preguntaCerrada={'Aqui pon la pregunta que quieres que salga'}>

</PreguntaCerradaEncuesta> */}


function PreguntaCerradaEncuesta({ preguntaCerrada }) {
  return (
    <div className="contenedorPreguntaCerradaEncuesta">
      <div className="textoPreguntaCerradaEncuesta"> {preguntaCerrada} </div>

      <div>
        <label for="contactChoice1">
          <input type="radio" id="cal1" name="Calificacion" value="1" checked />
          <span
            style={{
              position: "relative",
              left: "-24px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            1
          </span>
        </label>

        <label for="contactChoice1">
          <input type="radio" id="cal2" name="Calificacion" value="2" checked />
          <span
            style={{
              position: "relative",
              left: "-24px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            2
          </span>
        </label>

        <label for="contactChoice1">
          <input type="radio" id="cal3" name="Calificacion" value="3" checked />

          <span
            style={{
              position: "relative",
              left: "-24px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            3
          </span>
        </label>

        <label for="contactChoice1">
          <input type="radio" id="cal4" name="Calificacion" value="4" checked />

          <span
            style={{
              position: "relative",
              left: "-24px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            4
          </span>
        </label>


        <label for="contactChoice1">
          <input type="radio" id="cal5" name="Calificacion" value="5" checked />
          <span
            style={{
              position: "relative",
              left: "-24px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            5
          </span>
        </label>

        <label for="contactChoice1">
          <input type="radio" id="cal6" name="Calificacion" value="6" checked />
          <span
            style={{
              position: "relative",
              left: "-25px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            6
          </span>
        </label>


        <label for="contactChoice1">
          <input type="radio" id="cal7" name="Calificacion" value="7" checked />
          <span
            style={{
              position: "relative",
              left: "-24px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            7
          </span>
        </label>

        <label for="contactChoice1">
          <input type="radio" id="cal8" name="Calificacion" value="8" checked />
          <span
            style={{
              position: "relative",
              left: "-25px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            8
          </span>
        </label>


        <label for="contactChoice1">
          <input type="radio" id="cal9" name="Calificacion" value="9" checked />
          <span
            style={{
              position: "relative",
              left: "-25px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            9
          </span>
        </label>

        <label for="contactChoice1">
          <input type="radio" id="cal10" name="Calificacion" value="10" checked />
          <span
            style={{
              position: "relative",
              left: "-28px",
              top: "-22px",
              fontSize: "20px"
            }}
          >
            10
          </span>
        </label>
        
      </div>
    </div>
  );
}

export default PreguntaCerradaEncuesta;
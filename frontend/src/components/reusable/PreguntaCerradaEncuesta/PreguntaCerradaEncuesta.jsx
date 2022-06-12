import React from "react";

import "./PreguntaCerradaEncuesta.css";


// eslint-disable-next-line no-lone-blocks
{/* <PreguntaCerradaEncuesta

preguntaCerrada={'Aqui pon la pregunta que quieres que salga'}>

</PreguntaCerradaEncuesta> */}


function PreguntaCerradaEncuesta({ preguntaCerrada, indexPregunta, respuesta = 0 }) {
  return (
  <div className="contenedorPreguntaCerradaEncuesta">
        <div className="textoPreguntaCerradaEncuesta"> 
          {preguntaCerrada} 
        </div>

      <div>


        <label for="contactChoice1">
          {
            respuesta === 1 ?
            (

              <input type="radio" id="cal1" name={ `Calificacion${indexPregunta}`} value="1"  checked={true}/>
            ):
            (
              <input type="radio" id="cal1" name={ `Calificacion${indexPregunta}`} value="1"  />
            )
          }
          <span 
          id="numeroPreguntaCerradaEncuesta"
            style={{
              position: "relative",
              left: "-24px",
              top: "-22px",
              fontSize: "20px"
            }
          
          }
          >
            1
          </span>
        </label>

        <label for="contactChoice1">
            {
              respuesta === 2 ?
              (
                <input type="radio" id="cal2" name={ `Calificacion${indexPregunta}` } value="2" checked={true} />

              ):
              (
                <input type="radio" id="cal2" name={ `Calificacion${indexPregunta}` } value="2"  />

              )
            }
          <span
          id="numeroPreguntaCerradaEncuesta"
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
          {
            respuesta === 3 ?
            (
              <input type="radio" id="cal3" name={ `Calificacion${indexPregunta}` } value="3" checked={true} />

            ):
            (
              <input type="radio" id="cal3" name={ `Calificacion${indexPregunta}` } value="3"  />

            )
          }

          <span
          id="numeroPreguntaCerradaEncuesta"
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

          {
            respuesta === 4 ?
            (
              <input type="radio" id="cal4" name={ `Calificacion${indexPregunta}` } value="4"  checked={true}/>

            ):
            (
              <input type="radio" id="cal4" name={ `Calificacion${indexPregunta}` } value="4"  />

            )
          }

          <span
          id="numeroPreguntaCerradaEncuesta"
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
          {
            respuesta === 5 ?
            (
              <input type="radio" id="cal5" name={ `Calificacion${indexPregunta}` } value="5"  checked={true}/>

            ):
            (
              <input type="radio" id="cal5" name={ `Calificacion${indexPregunta}` } value="5"  />

            )
          }
          <span
          id="numeroPreguntaCerradaEncuesta"
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
          {
            respuesta === 6 ?
            (

              <input type="radio" id="cal6" name={ `Calificacion${indexPregunta}` } value="6"  checked={true}/>
            ):
            (
              <input type="radio" id="cal6" name={ `Calificacion${indexPregunta}` } value="6" />

            )
          }
          <span
          id="numeroPreguntaCerradaEncuesta"
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
          {
            respuesta === 7 ?
            (

              <input type="radio" id="cal7" name={ `Calificacion${indexPregunta}` } value="7" checked={true} />
            ):
            (
              <input type="radio" id="cal7" name={ `Calificacion${indexPregunta}` } value="7"  />

            )
          }
          <span
          id="numeroPreguntaCerradaEncuesta"
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
          {
            respuesta === 8 ?
            (
              <input type="radio" id="cal8" name={ `Calificacion${indexPregunta}` } value="8"  checked={true}/>

            ):
            (
              <input type="radio" id="cal8" name={ `Calificacion${indexPregunta}` } value="8"  />

            )
          }
          <span
          id="numeroPreguntaCerradaEncuesta"
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
          {
            respuesta === 9?
            (
              <input type="radio" id="cal9" name={ `Calificacion${indexPregunta}` } value="9" checked={true} />

            ):
            (
              <input type="radio" id="cal9" name={ `Calificacion${indexPregunta}` } value="9"  />

            )
          }
          <span
          id="numeroPreguntaCerradaEncuesta"
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
          {
            respuesta === 10 ?
            (
          <input type="radio" id="cal10" name={ `Calificacion${indexPregunta}` } value="10"  checked={true}/>

            ):
            (
          <input type="radio" id="cal10" name={ `Calificacion${indexPregunta}` } value="10"  />

            )
          }
          <span
          id="numeroDiezPreguntaCerradaEncuesta"
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
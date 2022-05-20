import React from 'react';
import './tarjetaListaDesplegable.css';
import { AiOutlineCloseCircle } from "react-icons/ai";


const COLORES_TIPO_1 = [
    "blanco_tipo_1",
    "gris_tipo_1"
]

const COLORES_TIPO_2 = [
    "azul_tipo_2",
    "amarillo_tipo_2",
    "rojo_tipo_2"
];

const COLORES_TIPO_3 = [
    "blanco_tipo3",
    "verde_tipo3",
    "rojo_tipo3",
    "amarillo_tipo3"
];



const TarjetaListaDesplegable = (
    { 
        tipo, 
        claveUF,
        nombreUF,
        semestre = 0,
        colorTipo1,
        colorTipo3,
        horaAsesoria, 
        contenido  
    }) => {

    /* 
        
        DOCUMENTACION DEL COMPONENTE
        
        Notas importantes:
            -> Para poder usar el componente es importante tomar en cuenta que existen 3 tipos de tarjetas:
                Tipo 1 => es aquella que solo muestra la clave de la Unidad de Formacion y el Nombre de la Unidad de formacion 
                Tipo 2 => aquella que muestra el semenstre, clave de UF, nombre de UF y tiene un boton para quitarla de la lista
                Tipo 3 => aquella que muestra la hora de asesoria, el estatus de la asesoria y la clave de la UF.

            -> el color de la tarjeta tipo 2, se definirá automaticamente a traves de la propiedad "semestre"
            ->Los colores estan definidos en este archivo en la parte de arriba. Estos deberan de ser pasados de manera exacta 
                a las properties correspondientes.
        
        Uso:
            ->Propiedades:
                -> tipo : tipo entero con rango de 1 a 3.
                -> claveUF : tipo string, clave de una unidad de formacion.
                -> nombreUF: tipo string, nombre de una unidad de formacion.
                -> semestre: tipo int, rango de 1 a 3 (de momento)
                -> colorTipo1: tipo string, es la cadena que se debe poner para poner el color a la tarjeta tipo 1.
                -> colorTipo3: tipo string, es la cadena que se debe poner para poner el color a la tarjeta tipo 3.
                -> horaAsesoria: tipo string, es la cadena del horario ,esta debe cumplir el formato:  "{hora} AM/PM".
                -> contenido: tipo string, es la cadena que ira dento de la tarjeta de tipo 3.

        Ejemplo de uso:
            Tipo1:  <TarjetaListaDesplegable tipo={ 1 } claveUF="TC3005B"  nombreUF="Desarrollo de software" colorTipo3="verde" />
            Tipo2:  <TarjetaListaDesplegable tipo={ 2 } claveUF="TC3005B"  nombreUF="Desarrollo de software"  semestre={1} />
            Tipo3:  <TarjetaListaDesplegable tipo={ 3 } claveUF="TC3005B" colorTipo3="verde_tipo3" horaAsesoria="11 AM" contenido=" Ezequiel Lozano Guerrero le dará asesoria a Daniel Maldonado Espitia " />



    */

    //definimos los colores de cada tipo de tarjeta
    const BackgroundColor3 = COLORES_TIPO_3.includes(colorTipo3) ? colorTipo3 :COLORES_TIPO_3[0];
    const BackgroundColor2 = semestre != 0 ? COLORES_TIPO_2[semestre-1] : COLORES_TIPO_2[0]; 
    const BackgroundColor1 = COLORES_TIPO_1.includes( colorTipo1 )? colorTipo1: COLORES_TIPO_1[0];
        
  return (

    <>
        <div className={ `contenedor-TarjetaListaDesplegable tipo${ tipo }` }> 
            {
                //dependiedo del tipo de tarjeta, se renderiza el HTMl correspondiente
                tipo === 1 ?
                (
                    <table className={`tabla-tipo-1 ${ BackgroundColor1 }`}> 
                    <tbody>
                        <tr className='fila-general-TarjetaListaDesplegable'>
                            <td className='claveUF-tipo-1' > { claveUF } </td>
                            <td className='nombreUF-tipo-1'> { nombreUF } </td>
                        </tr>
                    </tbody>
                    </table>
                ):
                (
                    tipo === 2?
                    (
                        <table className={`tabla-tipo-2 ${ BackgroundColor2 }`}> 
                        <tbody>
                            <tr className='fila-general-TarjetaListaDesplegable'>
                                <td className='semestre-tipo-2' >Semestre: { semestre }</td>
                                <td className='claveUF-tipo-2' > { claveUF } </td>
                                <td className='nombreUF-tipo-2' > { nombreUF } </td>
                                <td className='btn-cerrar-tipo2' onClick={ () => { window.alert("debería cerrarme :)") } }> <AiOutlineCloseCircle/> </td>
                            </tr>
                        </tbody>
                        </table>
                    ):
                    tipo === 3?
                    (
                        <table className={`tabla-tipo-3 ${ BackgroundColor3 }`}> 
                        <tbody>
                            <tr className='fila-general-TarjetaListaDesplegable'>
                                <td className='hora-asesoria-tipo-3' > { horaAsesoria } </td>
                                <td className='contenido-tipo-3' > { contenido } </td>
                                <td className='claveUF-tipo-3' > {claveUF} </td>
                            </tr>
                        </tbody>
                        </table>
                    ):
                    (
                        <h1>Hola</h1>
                    )
                )
            }
        </div>    
    </>
  )
}

export default TarjetaListaDesplegable
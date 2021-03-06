import React, { useState } from 'react';
import './tarjetaListaDesplegable.css';
import { AiOutlineCloseCircle } from "react-icons/ai";


const COLORES_TIPO_1 = [
    "blanco_tipo_1",
    "gris_tipo_1"
]

const COLORES_TIPO_2 = [
    "azul_tipo_2",
    "amarillo_tipo_2",
    "rojo_tipo_2",
    "azul_tipo_2",
    "amarillo_tipo_2",
    "rojo_tipo_2",
    "azul_tipo_2",
    "amarillo_tipo_2",
    "rojo_tipo_2",
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
        contenido,
        matricula,
        nombreAsesor,
        accion,
        imagenUsuario,
        getUFSelected,
        idEncuestado,
        idAsesoria,
        getAsesorSelected,
        getGrupoSelected
    }) => {

    /* 
        
        DOCUMENTACION DEL COMPONENTE
        
        Notas importantes:
            -> Para poder usar el componente es importante tomar en cuenta que existen 3 tipos de tarjetas:
                Tipo 1 => es aquella que solo muestra la clave de la Unidad de Formacion y el Nombre de la Unidad de formacion 
                Tipo 2 => aquella que muestra el semenstre, clave de UF, nombre de UF y tiene un boton para quitarla de la lista
                Tipo 3 => aquella que muestra la hora de asesoria, el estatus de la asesoria y la clave de la UF.
                Tipo 4 => aquella que muestra el semenstre, clave de UF, nombre de UF , pero sin boton de quitar

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
            Tipo1:  <TarjetaListaDesplegable tipo={ 1 } claveUF="TC3005B"  nombreUF="Desarrollo de software" colorTipo1="blanco_tipo_1" />
            Tipo2:  <TarjetaListaDesplegable tipo={ 2 } claveUF="TC3005B"  nombreUF="Desarrollo de software"  semestre={1} />
            Tipo3:  <TarjetaListaDesplegable tipo={ 3 } claveUF="TC3005B" colorTipo3="verde_tipo3" horaAsesoria="11 AM" contenido=" Ezequiel Lozano Guerrero le dará asesoria a Daniel Maldonado Espitia " />
            Tipo4:  <TarjetaListaDesplegable tipo={ 4 } claveUF="TC3005B"  nombreUF="Desarrollo de software"  semestre={1} />
            


    */

    //definimos los colores de cada tipo de tarjeta
    const BackgroundColor3 = COLORES_TIPO_3.includes(colorTipo3) ? colorTipo3 :COLORES_TIPO_3[0];
    const BackgroundColor2 = semestre !== 0 ? COLORES_TIPO_2[semestre-1] : COLORES_TIPO_2[0]; 
    const BackgroundColor1 = COLORES_TIPO_1.includes( colorTipo1 )? colorTipo1: COLORES_TIPO_1[0];


    const [activo, setActivo] = useState(false);
    
    const handleActivo = () => {
        setActivo(!activo);
    }

    const selectAsesor = () => {
        handleActivo();
        getAsesorSelected(matricula);
    }

    const selectGrupo = (grupo) => {
        handleActivo();
        getGrupoSelected(grupo);
    }

    const selectUF = () => {
        handleActivo()
        getUFSelected({claveUF, nombreUF})
    }

    const deleteUF = () => {
        getUFSelected(claveUF)
    }
        
  return (

    <>
        <div className={ `contenedor-TarjetaListaDesplegable tipo${ (tipo === 7) ? 3 : tipo }` } > 
            {
                //dependiedo del tipo de tarjeta, se renderiza el HTMl correspondiente
                tipo === 1 ?
                (
                    // <table className={`tabla-tipo-1 ${  !activo?  BackgroundColor1: "gris_tipo_1" }`} onClick={ selectUF } > 
                    <table className={`tabla-tipo-1 ${ BackgroundColor1 }`} onClick={ selectUF } >

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
                                    <td className='btn-cerrar-tipo2' onClick={ deleteUF }> <AiOutlineCloseCircle/> </td>
                                </tr>
                            </tbody>

                        </table>
                    ):
                    tipo === 3?
                    (
                        <table className={`tabla-tipo-3 ${ BackgroundColor3 }`} onClick={ idAsesoria ? () => accion(idAsesoria, idEncuestado) : accion } > 

                            <tbody>
                                <tr className='fila-general-TarjetaListaDesplegable'>
                                    <td className='hora-asesoria-tipo-3' > { horaAsesoria } </td>
                                    <td className='contenido-tipo-3' > { contenido.toUpperCase() } </td>
                                    <td className='claveUF-tipo-3' > {claveUF} </td>
                                </tr>
                            </tbody>

                        </table>
                    ):
                    (
                        tipo === 4?
                        (
                            <table className={`tabla-tipo-4 ${ BackgroundColor2 }`}> 

                                <tbody>
                                    <tr className='fila-general-TarjetaListaDesplegable'>
                                        <td className='semestre-tipo-4' >Semestre: { semestre }</td>
                                        <td className='claveUF-tipo-4' > { claveUF } </td>
                                        <td className='nombreUF-tipo-4' > { nombreUF } </td>
                                    </tr>
                                </tbody>

                            </table>
                        ):
                        (
                            tipo === 5?
                            (
                                <table className={`tabla-tipo-1 ${  !activo?  BackgroundColor1: "gris_tipo_1" }`} onClick={ selectAsesor } > 

                                    <tbody>
                                        <tr className='fila-general-TarjetaListaDesplegable'>
                                            <td className='claveUF-tipo-1' > { matricula } </td>
                                            <td className='nombreUF-tipo-1'> { nombreAsesor } </td>
                                        </tr>
                                    </tbody>
        
                                </table>
                            )
                            :
                            (
                                tipo === 6?
                                (
                                <table className={`tabla-tipo-1 ${  !activo?  BackgroundColor1: "gris_tipo_1" }`} onClick={ handleActivo } > 
                                
                                    <tbody>
                                        <tr className='fila-general-TarjetaListaDesplegable'>
                                            <td className='foto-user'> <img src={ imagenUsuario } alt="imagen-usuario" id="imagen-usuario-tipo5"/> </td>
                                            <td className='nombre-user' > { matricula } </td>
                                            <td className='matricula-user'> { nombreAsesor } </td>
                                        </tr>
                                    </tbody>
        
                                </table>
                                ):
                                (
                                    tipo === 7?
                                    (
                                        <table className={`tabla-tipo-3 ${ BackgroundColor3 }`} onClick={ () => {selectGrupo(contenido.toUpperCase())} } > 
                
                                            <tbody>
                                                <tr className='fila-general-TarjetaListaDesplegable'>
                                                    <td className='hora-asesoria-tipo-3' > { horaAsesoria } </td>
                                                    <td className='contenido-tipo-3' > { contenido.toUpperCase() } </td>
                                                    <td className='claveUF-tipo-3' > {claveUF} </td>
                                                </tr>
                                            </tbody>
                
                                        </table>
                                    ):
                                    (
                                        <h1>Hola</h1>
                                    )
                                )
                            )
                        )
                    )
                )
            }
        </div>    
    </>
  )
}

export default TarjetaListaDesplegable
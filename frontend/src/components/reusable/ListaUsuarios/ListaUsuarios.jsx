import React from 'react'
import { FaEdit, FaSearch } from "react-icons/fa";
import './listaUsuarios.css';


// const usuarios = [
//     {
//         "id": 1,
//         "nombreCompleto": "Daniel Esteban Maldonado Espitia"

//     },
//     {
//         "id": 2,
//         "nombreCompleto": "Daniel Munive Meneses"

//     },
//     {
//         "id": 3,
//         "nombreCompleto": "Daniel Flores Rodriguez"

//     },
//     {
//         "id": 4,
//         "nombreCompleto": "Ezequiel Lozano Guerrero"

//     },
//     {
//         "id": 5,
//         "nombreCompleto": "Fernando Jimenez"

//     },
//     {
//         "id": 6,
//         "nombreCompleto": "Emiliano Zapata"

//     },
//     {
//         "id": 5,
//         "nombreCompleto": "Leticia Rodríguez Aguilar"

//     }
// ]


const ListaUsuarios = ({ data }) => {


    /*
        DOCUMENTACION DEL COMPONENTE

        Notas importantes:
            -----

        uso:
            Properties:
            -> data. objeto que contendra la lista de usuarios que se desea renderizar en el componente, 
            el formato de este objeto, se muestra en la parte de arriba (objeto llamado usuarios)

        Ejemplo de uso:
            <ListaUsuarios data={ usuarios }/>

    */
  return (
    <>
        <div className='contenedorGeneral-ListaUsuarios'>
            <table className='tabla-ListaUsuarios'>
                <div className='espacio-para-overflow'></div>
                <tbody>
                    <tr className='encabazado-tabla-ListaUsuarios'>
                        <td className='contenedor-barraBusqueda'>
                            <input type='text' id='barraBusqueda-ListaUsuarios' placeholder={`Bucar Usuario`} />
                            <FaSearch className='icono-buscar-ListaUsuarios'/>
                        </td>
                        <td className='contenedor-texto-Accion'> 
                            <p>Acción</p>
                        </td>
                    </tr>

                    {
                        data.map((usuario, index) => (
                            <tr className='fila-elemento-ListaUsuarios' key={index}>
                                <td className='contenedor-matricula'>
                                    <p> {usuario.matricula} </p>
                                </td>
                                <td className='contenedor-nombre'>
                                    <p> {usuario.nombreCompleto} </p>
                                </td>
                                <td className='contenedor-btn-editar'>
                                    <a href='./administrarPerfilAsesorados' className='btn-editar-ListaUsuarios'> <FaEdit className='icono-btn-editar-ListaUsuarios'/> </a>
                                </td>
                            </tr>
                        ))
                    }
               </tbody>
            </table>
        </div>
    </>
  )
}

export default ListaUsuarios
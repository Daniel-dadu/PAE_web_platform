import React from 'react'
import { FaEdit, FaSearch } from "react-icons/fa";
import './listaUsuarios.css';
import data from'./pruebaListaUsuarios.json'


const ListaUsuarios = () => {
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
                        Object.keys(data['usuarios']).map((index) => {
                            return(
                            <tr className='fila-elemento-ListaUsuarios' key={index}>
                                <td className='contenedor-nombre'>
                                    <p>
                                        {data['usuarios'][index]['nombreCompleto']}
                                    </p>
                                </td>
                                <td className='contenedor-btn-editar'>
                                    <a href='#' className='btn-editar-ListaUsuarios'> <FaEdit className='icono-btn-editar-ListaUsuarios'/> </a>
                                </td>
                            </tr>
                            )
                        })
                    }
               </tbody>
            </table>
        </div>
    </>
  )
}

export default ListaUsuarios
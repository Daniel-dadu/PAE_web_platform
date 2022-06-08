import React from 'react'
import { FaEdit, FaSearch } from "react-icons/fa";
import './listaUsuarios.css';


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
const ListaUsuarios = ({ data, rol }) => {

    return (
        <div className='contenedorGeneral-ListaUsuarios'>
            <table className='tabla-ListaUsuarios'>
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
                                    <p> {usuario.nombrecompleto} </p>
                                </td>
                                <td className='contenedor-btn-editar'>
                                    <a href={`./administrarPerfil/${rol}/${usuario.matricula}`} className='btn-editar-ListaUsuarios'> 
                                        <FaEdit className='icono-btn-editar-ListaUsuarios'/>
                                    </a>
                                </td>
                            </tr>
                        ))
                    }
               </tbody>
            </table>
        </div>
  )
}

export default ListaUsuarios
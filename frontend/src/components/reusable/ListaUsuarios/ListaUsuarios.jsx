import React, { useEffect, useState } from 'react'
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

    const [textoBusqueda, setTextoBusqueda] = useState('')

    const [dataUsers, setDataUsers] = useState(data)

    // Cada vez que el texto de busqueda cambie, se actualiza la lista de usuarios dataUsers 
    useEffect(() => {
        setDataUsers( 
            textoBusqueda === '' ? data :
            data.filter(usr => usr.matricula.startsWith(textoBusqueda) || usr.nombrecompleto.startsWith(textoBusqueda))
        )
    }, [textoBusqueda, data, setDataUsers])

    return (
        <div className='contenedorGeneral-ListaUsuarios'>
            <table className='tabla-ListaUsuarios'>
                <tbody>
                    <tr className='encabazado-tabla-ListaUsuarios'>
                        <td className='contenedor-barraBusqueda'>
                            <input 
                                type='text' 
                                id='barraBusqueda-ListaUsuarios' 
                                placeholder='Bucar Usuario' 
                                onChange={({ target }) => setTextoBusqueda(target.value)}
                            />
                            <FaSearch className='icono-buscar-ListaUsuarios'/>
                            <span id="Texto_on_hover">Ingrese la matrícula o el nombre del usuario que busca</span>
                        </td>
                        <td className='contenedor-texto-Accion'> 
                            <p>Acción</p>
                        </td>
                    </tr>

                    {
                        dataUsers.map((usuario, index) => (
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
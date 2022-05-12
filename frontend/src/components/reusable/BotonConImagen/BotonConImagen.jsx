import React from 'react'
import './BotonConImagen.css'

const COLORS = [
    'negro',
    'azulCielo',
    'rojo',
    'gris',
    'turquesa',
    'verde',
    'blanco'
]

const SIZES = [
    'normal',
    'largo',
    'grande',
    'reducido'
]

// La imagen que se recibe solo puede ser un ícono de React
// El children es el texto
// Las opciones para backgroundColor y size están en los arrays de arriba

function BotonConImagen({ onClick, backgroundColor, size, Image, children }) {

    const ButtonBackground = COLORS.includes(backgroundColor) ? backgroundColor : COLORS[0];

    const ButtonSize = SIZES.includes(size) ? size : SIZES[0];

    return (
        <button className = {`btn ${ButtonBackground} ${ButtonSize}`} onClick = {onClick}>
            <p>{children}</p> <div><Image size={35} /></div>
        </button>
    )
}

export default BotonConImagen
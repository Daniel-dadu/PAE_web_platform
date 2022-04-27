import React from 'react'

const COLORS = [
    'negro',
    'azulCielo',
    'rojo',
    'gris',
    'turquesa',
    'verde'
]

const SIZES = [
    'normal',
    'largo',
    'grande',
    'reducido'
]

function BotonConImagen({ onClick, backgroundColor, size, children }) {

    const ButtonBackground = COLORS.includes(backgroundColor)
        ? backgroundColor
        : COLORS[0];

    const ButtonSize = SIZES.includes(size)
        ? size
        : SIZES[0];

    return (
        <button className = {`btn ${ButtonBackground} ${ButtonSize}`} onClick = {onClick}>
            {children}
        </button>
    )
}

export default BotonConImagen
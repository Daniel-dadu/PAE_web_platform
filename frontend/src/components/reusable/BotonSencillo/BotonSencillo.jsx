import React from 'react'
import '../../../index.css'
import './BotonSencillo.css'

const COLORS = [
    'negro',
    'azulCielo',
    'rojo',
    'gris',
    'turquesa',
    'verde',
    'amarillo'
]

const SIZES = [
    'normal',
    'largo',
    'grande',
    'reducido'
]

const BotonSencillo = ({
    onClick,
    backgroundColor,
    size,
    children // Contenido del botón
}) => {

    const ButtonBackground = COLORS.includes(backgroundColor)
        ? backgroundColor
        : COLORS[0];

    const ButtonSize = SIZES.includes(size)
        ? size
        : SIZES[0];

    return(
        <button
            className = {`btn ${ButtonBackground} ${ButtonSize}`}
            onClick = {onClick}
        >
            {children}
        </button>
    );

};

export default BotonSencillo
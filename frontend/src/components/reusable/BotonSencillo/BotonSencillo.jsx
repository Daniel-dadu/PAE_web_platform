import React from 'react'
import '../../../index.css'
import './BotonSencillo.css'

const STYLES = [
    'negro',
    'azulCielo',
    'rojo',
    'gris',
    'turquesa',
    'verde'
]

const SIZES = [
    'normal',
    'small',
    'large',
]

const BotonSencillo = ({
    onClick,
    type,
    buttonStyle,
    buttonSize,
    children // Contenido del botón
}) => {

    const checkButtonStyle = STYLES.includes(buttonStyle)
        ? buttonStyle
        : STYLES[0];

    const checkButtonSize = SIZES.includes(buttonSize)
        ? buttonSize
        : SIZES[0];

    return(
        <button
            className = {`btn ${checkButtonStyle} ${checkButtonSize}`}
            onClick = {onClick}
            type = {type}
        >
            {children}
        </button>
    );

};

export default BotonSencillo
import React from 'react'
import '../../../index.css'
import './ImagenAsesoria.css'
import { AiOutlineCloseCircle } from 'react-icons/ai';

// import axios from 'axios'
// import fileDownload from 'js-file-download'

// const handleClick = (url, filename) => {
//     axios.get(url, {
//         responseType: 'blob',
//     })
//     .then((res) => {
//         fileDownload(res.data, filename)
//     })
// };
// onClick = {handleClick("http://localhost:3000/static/media/goku.7ccd1205be59dd2e3e76.jpg", 'goku')}

const SIZES = [
    'normal',
    'larga',
    'ancha',
    'grande',
    'reducida'
]

const ImagenAsesoria = ({
    allowClosed, // Define si se puede o no cerrar la imagen
    onClickX, // Evento que ocurre al presionar la 'x' de la imagen
    size,
    source,
    alt,
    nameDownloadImage
}) => {

    const ImageSize = SIZES.includes(size)
        ? size
        : SIZES[0];

    if(parseInt(allowClosed)){

        return(
            <>
            <a href = {require(`./${source}`)} download = {nameDownloadImage}>
            <img
                className = {`img ${ImageSize}`}
                src = {require(`./${source}`)}
                alt = {alt}
            />
            </a>
            <AiOutlineCloseCircle size = "3em" className = ''/>
            </>
        )

    }
    else{

        return(
            <>
            <a href = {require(`./${source}`)} download = {nameDownloadImage}>
            <img
                className = {`img ${ImageSize}`}
                src = {require(`./${source}`)}
                alt = {alt}
            />
            </a>
            
            </>
        )

    }


};

export default ImagenAsesoria
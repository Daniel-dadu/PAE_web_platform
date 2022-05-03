import React from 'react'
import '../../../index.css'
import './ImagenAsesoria.css'
import { GrClose } from 'react-icons/gr';

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

const ImagenAsesoria = ({
    allowClosed, // Define si se puede o no cerrar la imagen
    onClickX, // Evento que ocurre al presionar la 'x' de la imagen
    size,
    source,
    alt,
    nameDownloadImage
}) => {

    return(
        <>
        <div className = {`divImg`}>
            <a href = {source} download = {nameDownloadImage}>
                <img
                    className = 'img'
                    src = {source} // {require(`./${source}`)}
                    alt = {alt}
                />
            </a>
            <div className = 'circle'>
            {
                parseInt(allowClosed)
                    ? <GrClose
                        onClick = {onClickX}
                        color = 'black'
                        className = 'closeCircle'/>
                    : <GrClose
                        style = {{display: 'none'}}/>
            }
            </div>
        </div>
        </>
    )

};

export default ImagenAsesoria
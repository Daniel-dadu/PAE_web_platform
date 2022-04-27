// 1. Uso del botón sencillo

// import React from 'react'
// import { BotonSencillo } from '../../../routeIndex'

// function Ezequiel() {
//   return (
//     <BotonSencillo
//       onClick = {() => {alert('Me diste click :)')}} // Acción que ocurre al dar click en el botón
//       backgroundColor = 'verde'
            // Elección del color de fondo:
              // negro
              // turquesa
              // azulCielo
              // verde
              // rojo
              // gris
//       size = 'reducido'
            // Elección del tamaño del botón:
                // normal
                // largo
                // reducido
                // grande
//     >
//       Aceptar // Contenido del botón
//     </BotonSencillo>
//   )
// }

// export default Ezequiel

// 2. Uso del componente de la imagen

import React from 'react'
import { ImagenAsesoria } from '../../../routeIndex'

function Ezequiel() {
  return (
    <ImagenAsesoria
      allowClosed = '1'
        // 0 significa que NO puede cerrarse (NO tiene la equis en la esquina)
        // 1 significa que SÍ puede cerrarse (tiene la equis en la esquina)
      onClickX = {() => {alert('Debo quitar la imagen :)')}}
        // Acción que debe quitar la imagen y descartar de subir la ruta de la misma en la asesoría a agendar
        // Nota, solo se debe ocupar este atributo si el allowClosed es '1',
        // de lo contrario se debe dejar como '{}'
      size = 'normal'
        // normal
        // larga
        // ancha
        // grande
        // reducida
      source = 'imgPrueba/goku.jpg'
        // Se debe poner la ruta LOCAL de la imagen
        // NOTA: ESTÁ PENDIENTE ELEGIR BIEN LA RUTA DONDE ESTAS SE GUARDARÁN,
        // POR LO QUE, POR AHORA SE ASUME QUE SE PARTE DE LA CARPETA DE ESTE COMPONENTE (ImagenAsesoria)
        // Ejemplo: hay una imagen llamada goku.jpg en la ruta 'components/reusable/ImagenAsesoria/imgPrueba/goku.jpg',
        // por lo cual, se le da el valor de source como 'imgPrueba/goku.jpg'
      alt = 'Goku' // Nombre alterno de la imagen
      nameDownloadImage = 'El meme de Goku' // Nombre de la imagen al ser descargada
    >
    </ImagenAsesoria>
  )
}

export default Ezequiel
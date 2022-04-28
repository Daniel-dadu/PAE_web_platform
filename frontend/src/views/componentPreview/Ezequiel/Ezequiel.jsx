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

// import React from 'react'
// import { ImagenAsesoria } from '../../../routeIndex'

// function Ezequiel() {
//   return (
//     <ImagenAsesoria
//       allowClosed = '1'
//         // 0 significa que NO puede cerrarse (NO tiene la equis en la esquina)
//         // 1 significa que SÍ puede cerrarse (tiene la equis en la esquina)
//       onClickX = {() => {alert('Debo quitar la imagen :)')}}
//         // Acción que debe quitar la imagen y descartar de subir la ruta de la misma en la asesoría a agendar
//         // Nota, solo se debe ocupar este atributo si el allowClosed es '1',
//         // de lo contrario se debe dejar como '{}'
//       size = 'reducida'
//         // normal
//         // larga
//         // ancha
//         // grande
//         // reducida
//       source = 'imgPrueba/DebianLogo.png'
//         // Se debe poner la ruta LOCAL de la imagen
//         // NOTA: ESTÁ PENDIENTE ELEGIR BIEN LA RUTA DONDE ESTAS SE GUARDARÁN,
//         // POR LO QUE, POR AHORA SE ASUME QUE SE PARTE DE LA CARPETA DE ESTE COMPONENTE (ImagenAsesoria)
//         // Ejemplo: hay una imagen llamada DebianLogo.png en la ruta 'components/reusable/ImagenAsesoria/imgPrueba/DebianLogo.png',
//         // por lo cual, se le da el valor de source como 'imgPrueba/DebianLogo.png'
//       alt = 'Debian' // Nombre alterno de la imagen
//       nameDownloadImage = 'La imagen de Debian' // Nombre de la imagen al ser descargada
//     >
//     </ImagenAsesoria>
//   )
// }

// export default Ezequiel

// 3. Uso del componente del día del calendario

import React from 'react'
import { DiaCalendario } from '../../../routeIndex'
import AsesoriasJSON from '../../../components/reusable/DiaCalendario/PruebaAsesorias.json'

function Ezequiel() {
  return (
    <DiaCalendario
      isActive = '1' // Determina si hay o no asesorías en ese día
        // 0 significa que no hay asesorías agendadas
        // 1 significa que hay asesorías agendadas
      userType = 'alumno' // Se usa si hay al menos una asesoría agendada en ese día
        // alumno
        // directivo
      onClickDirectivo = {() => {alert('Debo abrir la pantalla de asesorías existentes :)')}}
        // Se usa solo si el tipo de usuario es un directivo
        // El evento de click se aplica al botón de 'Múltiples asesorías'
      asesorias = {AsesoriasJSON} // Se usa solo si hay al menos una asesoría agendada y el tipo de usuario es 'alumno'
        // JSON con las asesorías del día
        // NOTA: en el archivo JSON debe existir un campo "status", "hora" y "openPanel",
        // este último debe almacenar la función para abrir el panel de cada asesoría en específico.
        // Para comprender mejor esto se debe ver el archivo 'PruebaAsesorias.json' encontrado en la carpeta de este componente
      numeroDia = '23' // Número del día del componente
      size = 'normal' // Tamaño del componente
        // normal
        // grande
        // reducido
    >
    </DiaCalendario>
  )
}

export default Ezequiel
// Código tomado en gran parte de https://stackoverflow.com/questions/51809241/how-to-compress-a-base64-image-to-custom-size

// Función que recibe la imagen de tipo "new Image()" y su extensión (.jpg/.png)
// y regresa la imagen con un tamaño muy cercano al max_size establecido
const resize = async (img, type, MAX_SIZE) => {

    const MIN_SIZE = MAX_SIZE*0.75 // 75% of max_size

    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')
    
    ctx.drawImage(img, 0, 0)
    
    let width = img.width
    let height = img.height

    // Se establece 1200 pixeles como la altura o anchura máxima que puede tener una imagen
    const MAX_WH = 1200 
    
    // keep portration
    if (width > height) {
        if (width > MAX_WH) {
            height *= MAX_WH / width
            width = MAX_WH
        }
    } else {
        if (height > MAX_WH) {
            width *= MAX_WH / height
            height = MAX_WH
        }
    }

    let start = 0
    let end = 1
    let last, blob
    
    canvas.width = width
    canvas.height = height
    ctx.drawImage(img, 0, 0, width, height)
    
    blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, 1))
    
    console.log("1 RESIZING: Blob size", blob.size)
    if (blob.size < MAX_SIZE) return blob
    
    let blobOptions = []

    // Binary search para encontrar el tamaño más cercano a los límites
    while (true) {
        const mid = Math.round( ((start + end) / 2) * 100 ) / 100
        if (mid === last || (blob.size < MAX_SIZE && blob.size > MIN_SIZE)) break
        last = mid
        blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, mid))
        console.log("RESIZING: Blob size", blob.size)
        blobOptions.push(blob)
        if (blob.size > MAX_SIZE) end = mid 
        if (blob.size < MAX_SIZE) start = mid
    }

    if(blob.size > MAX_SIZE){
        blobOptions.sort((a, b) => a.size > b.size ? 1 : -1)
        for (let i = blobOptions.length-1; i >= 0; i--) {
            console.log(`Blob option ${i}`, blobOptions[i].size)
            if(blobOptions[i].size < MAX_SIZE) return blobOptions[i]
        }
        return "error: imagen muy grande"
    } else {
        return blob
    }
}

// Función que convierte un archivo blob a base64
// Tomada de: https://stackoverflow.com/questions/18650168/convert-blob-to-base64
function blobToBase64(blob) {
    return new Promise((resolve, _) => {
      const reader = new FileReader();
      reader.onloadend = () => resolve(reader.result);
      reader.readAsDataURL(blob);
    });
}

// Función que comprime la imagen al máximo tamaño de bytes que recibe en MAX_SIZE
// ENTRADA: esta recibe la imagen en base64imageStr y el número de bytes en MAX_SIZE
// SALIDA: regresa un string con la imagen en base64, EN FORMATO webp
// ---------- IMPORTANTE: Esta función se debe llamar dentro de una función asyncrona y se debe poner el await al llamarla
// Ejemplo de uso:
/*
const updateFoto = async () => {    
    let imageCompressed = await imageCompressor(images[0].data_url, 20000)
    console.log(imageCompressed)
}
*/
const imageCompressor = async (base64imageStr, MAX_SIZE = 50000) => { // por defecto se establecen 50kb

    let imageObject = new Image()
    imageObject.src = base64imageStr
    
    let blob = await resize(imageObject, 'webp', MAX_SIZE)

    let result = typeof blob === 'string' ? blob : await blobToBase64(blob)

    return result
}

export default imageCompressor
// Código tomado en gran parte de https://stackoverflow.com/questions/51809241/how-to-compress-a-base64-image-to-custom-size

// Función que recibe la imagen de tipo "new Image()" y su extensión (.jpg/.png)
// y regresa la imagen con un tamaño muy cercano al max_size establecido
const resize = async (img, type, MAX_SIZE) => {

    const MIN_SIZE = MAX_SIZE*0.9 // 90% of max_size

    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')
    
    ctx.drawImage(img, 0, 0)
    
    let width = img.width
    let height = img.height
    let start = 0
    let end = 1
    let last, blob
    
    canvas.width = width
    canvas.height = height
    ctx.drawImage(img, 0, 0, width, height)
    
    blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, 1))
    
    if (blob.size < MAX_SIZE) return blob
    
    // Binary search para encontrar el tamaño más cercano a los límites
    while (true) {
        const mid = Math.round( ((start + end) / 2) * 100 ) / 100
        if (mid === last || (blob.size < MAX_SIZE && blob.size > MIN_SIZE)) break
        last = mid
        blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, mid))
        if (blob.size > MAX_SIZE) end = mid 
        if (blob.size < MAX_SIZE) start = mid
    }

    return blob
}

// Función que comprime la imagen al máximo tamaño de bytes que recibe en MAX_SIZE
// ENTRADA: esta recibe la imagen en base64imageStr y el número de bytes en MAX_SIZE
// SALIDA: regresa un string con la imagen en base64, EN FORMATO webp
const imageCompressor = (base64imageStr, MAX_SIZE = 50000) => { // por defecto se establecen 50kb
    
    let imageObject = new Image()
    imageObject.src = base64imageStr
    
    // Se le indica a la función que regrese la imagen en formato 'webp' ya que es el formato que más cuida la calidad de imagen
    resize(imageObject, 'webp', MAX_SIZE).then(blob => {

        let reader = new FileReader()
        reader.readAsDataURL(blob)
        reader.onloadend = () => {
            var base64data = reader.result           
            console.log('----- Final result -----:', base64data); // __________ ¡¡¡¡¡¡¡QUITAAAAAR!!!!!!! __________
            return base64data
        }
    })
}

export default imageCompressor
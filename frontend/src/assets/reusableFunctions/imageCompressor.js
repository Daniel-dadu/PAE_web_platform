// Código tomado en gran parte de https://stackoverflow.com/questions/51809241/how-to-compress-a-base64-image-to-custom-size

const resize = async (img, type) => {

    const MAX_SIZE = 50000 // 50kb
    const MIN_SIZE = 45000 // 45kb

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
    
    // Binary search for the right size
    while (true) {
        const mid = Math.round( ((start + end) / 2) * 100 ) / 100
        if (mid === last || (blob.size < MAX_SIZE && blob.size > MIN_SIZE)) break
        last = mid
        blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, mid))
        console.log(`Quality set to ${mid} gave a Blob size of ${blob.size} bytes`)
        if (blob.size > MAX_SIZE) end = mid 
        if (blob.size < MAX_SIZE) start = mid
    }

    return blob
  }

const imageCompressor = (base64imageStr) => {
    
    let imageObject = new Image()
    imageObject.src = base64imageStr
    
    console.log('Converting image to webp\n')

    resize(imageObject, 'webp').then(blob => {
        console.log('Final blob size', blob.size)

        let reader = new FileReader();
        reader.readAsDataURL(blob); 
        reader.onloadend = () => {
            var base64data = reader.result;                
            console.log('----- Final result -----:', base64data);
            return base64data
        }
    })
}

export default imageCompressor
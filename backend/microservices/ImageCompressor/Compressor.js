import fetch from "node-fetch";

// https://stackoverflow.com/questions/51809241/how-to-compress-a-base64-image-to-custom-size

console.log('Downloading lorem ipsum image to simulate a file from user input')

fetch('https://picsum.photos/1920/1080/?random')
.then(res => res.blob())
.then(blob => {
  const img = new Image()
  img.src = URL.createObjectURL(blob)

  console.log(`Original image size (at 1920x1080) is: ${blob.size} bytes`)
  console.log('URL to original image:', img.src)
  
  img.onload = () => resize(img, 'jpeg').then(blob => {
    console.log('Final blob size', blob.size)
    console.log('Final blob url:', URL.createObjectURL(blob))

    console.log('\nNow with webp\n')

    resize(img, 'webp').then(blob => {
      console.log('Final blob size', blob.size)
      console.log('Final blob url:', URL.createObjectURL(blob))
    })
  })
}) 


const MAX_WIDTH = 1280
const MAX_HEIGHT = 720
const MAX_SIZE = 100000 // 100kb

async function resize(img, type = 'jpeg') {
  const canvas = document.createElement('canvas')
  const ctx = canvas.getContext('2d')
  
  ctx.drawImage(img, 0, 0)
  
  let width = img.width
  let height = img.height
  let start = 0
  let end = 1
  let last, accepted, blob
  
  // keep portration
  if (width > height) {
    if (width > MAX_WIDTH) {
      height *= MAX_WIDTH / width
      width = MAX_WIDTH
    }
  } else {
    if (height > MAX_HEIGHT) {
      width *= MAX_HEIGHT / height
      height = MAX_HEIGHT
    }
  }
  canvas.width = width
  canvas.height = height
  console.log('Scaling image down to max 1280x720 while keeping aspect ratio')
  ctx.drawImage(img, 0, 0, width, height)
  
  accepted = blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, 1))
  
  if (blob.size < MAX_SIZE) {
    console.log('No quality change needed')
    return blob
  } else {
    console.log(`Image size after scaling ${blob.size} bytes`)
    console.log('Image sample after resizeing with losseless compression:', URL.createObjectURL(blob))
  }
  
  // Binary search for the right size
  while (true) {
    const mid = Math.round( ((start + end) / 2) * 100 ) / 100
    if (mid === last) break
    last = mid
    blob = await new Promise(rs => canvas.toBlob(rs, 'image/'+type, mid))
        console.log(`Quality set to ${mid} gave a Blob size of ${blob.size} bytes`)
    if (blob.size > MAX_SIZE) { end = mid }
    if (blob.size < MAX_SIZE) { start = mid; accepted = blob }
  }

  return accepted
}
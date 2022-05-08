// Modulo necesario, lo incluye Node
var crypto = require('crypto');

// getSalt: generates random string of characters i.e salt
const getSalt = () => {
    const length = 16
    return crypto.randomBytes(Math.ceil(length/2))
            .toString('hex') // convert to hexadecimal
            .slice(0,length) // return required number of characters
}

// getPassword: recieves a password and the salt and hashes it
const getPassword = (password, salt) => {
    let hash = crypto.createHmac('sha512', salt) // Hashing algorithm sha512
    hash.update(password)
    let passHashed = hash.digest('hex')
    return passHashed
}

module.exports = {
    getSalt,
    getPassword
}
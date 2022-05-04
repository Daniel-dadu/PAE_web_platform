const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3095

const db = require('./queries')

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

app.get('/', (request, response) => {
    response.json({ info: 'Node.js, Express, and Postgres API' })
})

app.get('/login/:user', db.validateCredentials)


app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})
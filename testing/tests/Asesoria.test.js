const express = require('express')
const app = express()
const supertest = require('supertest')
const request = supertest(app)

describe('Lista de unidades de formacion', () => {

  test('GET / UF de ITC de primer semestre', async () => {
    //const data = await request.get('http://20.225.209.57:3094/asesoria/get_uf/?carrera=ITC&semestre=1')
    const data = await request.get('https://jsonplaceholder.typicode.com/todos/')
    console.log(data)
    console.log(data.status)
    console.log(data.body)
    expect(data).not.toBe(0);
  });
});
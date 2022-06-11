const request = require('supertest')
let URL = 'http://20.225.209.57:3094/asesoria/';

describe('Test', () => {

  beforeAll(() => {
    URL += "get_uf"
    });

  afterAll(() => {
    URL = 'http://20.225.209.57:3094/asesoria/'
  });

  test('GET sin parametros', async () => {
    await request(URL)
        .get('/')
        .expect(404);
  });

  test('GET primer semestre de ITC', async () => {
    await request(URL)
    .get('/?carrera=ITC&semestre=1')
    .expect(200);
  });

  test('GET primer semestre de ITC regresa una lista con elementos', async () => {
    const response = await request(URL)
        .get('/?carrera=ITC&semestre=1')
    expect(response.body.length).toBeGreaterThan(0);
  });
});
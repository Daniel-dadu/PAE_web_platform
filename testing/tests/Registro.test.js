const request = require('supertest')
let URL = 'http://20.225.209.57:3090/registro/';
let fotoB64 = ''

//http://20.225.209.57:3090/registro/prueba_get_foto?matricula=A01657967
describe('GET / Prueba get foto', () => {

    beforeAll(() => {
        URL += "prueba_get_foto"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3090/registro/'
    });

    test('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            expect(200);
    });

    test('GET foto de A01657967', async () => {
        const response = await request(URL)
            .get('/?matricula=A01657967')
        fotoB64 = response.body.fotoPerfil
        expect(response.statusCode).toBe(200)
        expect(response.body.fotoPerfil).not.toBeNull()
    });

});
//http://20.225.209.57:3090/registro/prueba_foto
describe('PUT / Prueba de foto', () => {

    beforeAll(() => {
        URL += "prueba_foto"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3090/registro/'
    });

    test('PUT sin parametros', async () => {
        await request(URL)
            .put('/')
            .expect(200);
    });

    test('PUT actualizar con la misma foto a A01657967', async () => {
        const data = {
            matricula: "A01657967",
            fotoPerfil: fotoB64
        }
        
        await request(URL)
            .put('/')
            .set('Content-type', 'application/json')
            .send(data)
            .expect(200);
    });
});

//http://20.225.209.57:3090/registro/politica_vigente
describe('GET / Politica vigente', () => {

    beforeAll(() => {
        URL += "politica_vigente"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3090/registro/'
    });

    test('GET sin parametros', async () => {
        const response = await request(URL)
            .get('/')
        expect(response.statusCode).toBe(200)
        expect(response.body).not.toBeNull()
    });
});

//http://20.225.209.57:3090/registro/nuevo_asesorado
describe('POST / Registrar nuevo asesorado', () => {

    const usuarioPrueba = {
        matricula: 'A01734609',
        contrasena: 'sudo',
        nombre: 'El Fer',
        apellidoPaterno: 'Dios',
        apellidoMaterno: 'Del Server',
        fotoPerfil: fotoB64,
        telefono: '777',
        carrera: 'ITC'
    }

    beforeAll(() => {
        URL += "nuevo_asesorado"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3090/registro/'
    });

    test('POST sin parametros', async () => {
        const data = {}
        await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)
            .expect(500);
    });

    test.skip('POST registrar nuevo asesorado', async () => {

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(usuarioPrueba)

        expect(response.statusCode).toBe(200);
    });

    test('POST registrar el mismo asesorado', async () => {
        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(usuarioPrueba)

        expect(response.statusCode).toBe(409);
    });
});

//http://20.225.209.57:3090/registro/nuevo_asesor
//Por hacer
describe.skip('POST / Registrar nuevo asesor', () => {

    const usuarioPrueba = {
        matricula: 'A01734666',
        contrasena: 'sudo',
        nombre: 'El Fer',
        apellidoPaterno: 'Dios',
        apellidoMaterno: 'Del Server',
        fotoPerfil: fotoB64,
        telefono: '777',
        carrera: 'ITC',
        semestre: 6
    }

    beforeAll(() => {
        URL += "nuevo_asesor"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3090/registro/'
    });

    test('POST sin parametros', async () => {
        const data = {}
        await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)
            .expect(500);
    });

    test.skip('POST registrar nuevo asesor', async () => {

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(usuarioPrueba)

        expect(response.statusCode).toBe(200);
    });

    test('POST registrar el mismo asesor', async () => {
        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(usuarioPrueba)

        expect(response.statusCode).toBe(409);
    });
});
const request = require('supertest')
let URL = 'http://20.225.209.57:3091/general/';

//http://20.225.209.57:3091/general/get_carreras/
describe('GET / Carreras', () => {

    beforeAll(() => {
        URL += "get_carreras"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3091/general/'
    });

    test('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            .expect(200);
    });

});

//http://20.225.209.57:3091/general/meses_inicio_fin_semestre/
describe('GET / Inicio y fin de semestre', () => {

    beforeAll(() => {
        URL += "meses_inicio_fin_semestre"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3091/general/'
    });

    test('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            .expect(200);
    });

});

//http://20.225.209.57:3091/general/nombre_uf/?id_uf=TC1028
//Falta documentacion
describe('GET / Nombre de unidad de formacion', () => {

    beforeAll(() => {
        URL += "nombre_uf"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3091/general/'
    });

    //deberia ser 200?
    test('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            .expect(200);
    });

    test('GET nombre de TC1028', async () => {
        const response = await request(URL)
            .get('/?id_uf=TC1028')
        expect(response.statusCode).toBe(200)
        expect(Object.keys(response.body).length).toBe(1)
        expect(response.body.nombreUF).toBe('Pensamiento computacional para ingeniería');
    });


});

//http://20.225.209.57:3091/general/get_ufs_carreras/?carrera1=ITC&carrera2=IBT
describe('GET / Unidades de formacion de carrera', () => {

    beforeAll(() => {
        URL += "get_ufs_carreras"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3091/general/'
    });

    //deberia ser 200?
    test('GET sin parametros', async () => {
            await request(URL)
            .get('/')
            .expect(200);
    });

    test('GET carrera1', async () => {
        const response = await request(URL)
            .get('/?carrera1=ITC')

            expect(response.body[0].unidadesFormacion.length).toBeGreaterThan(0)
            expect(response.statusCode).toBe(200)
    });

    test('GET carrera2', async () => {
        const response = await request(URL)
            .get('/?carrera2=IBT')

            expect(response.body[0].unidadesFormacion.length).toBeGreaterThan(0)
            expect(response.statusCode).toBe(200)
    });

    test('GET carrera1 y carrera2', async () => {
        const response = await request(URL)
            .get('/?carrera1=ITC&carrera2=IBT')

            expect(response.body[0].unidadesFormacion.length).toBeGreaterThan(0)
            expect(response.statusCode).toBe(200)
    });

});
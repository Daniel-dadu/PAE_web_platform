const request = require('supertest')
let URL = 'http://20.225.209.57:3031/calendario/';

// http://20.225.209.57:3031/calendario/get_asesorias/?idUsuario=A01657967&mes=2&anio=2022
describe.skip('GET / Asesorias de un usuario', () => {

    beforeAll(() => {
        URL += "get_asesorias"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3031/calendario/'
    });

    //Deberia devolve {}?
    test('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Asesorias con solo el usuario', async () => {
        await request(URL)
            .get('/?idUsuario=A01657967')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Asesorias con solo el mes', async () => {
        await request(URL)
            .get('/?mes=2')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Asesorias con solo el anio', async () => {
        await request(URL)
            .get('/?anio=2022')
            .expect(200);
    });

    test('GET Asesorias de A01657967 en el mes de marzo del 2022', async () => {
        await request(URL)
            .get('/?idUsuario=A01657967&mes=2&anio=2022')
            .expect(200);
    });

});

// http://20.225.209.57:3031/calendario/get_allAsesorias/?mes=2&anio=2022
describe.skip('GET / Asesorias de todos los usuarios', () => {

    beforeAll(() => {
        URL += "get_allAsesorias"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3031/calendario/'
    });

    //Deberia devolve {}?
    test('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Asesorias con solo el mes', async () => {
        await request(URL)
            .get('/?mes=2')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Asesorias con solo el anio', async () => {
        await request(URL)
            .get('/?anio=2022')
            .expect(200);
    });

    test('GET Asesorias en el mes de marzo del 2022', async () => {
        await request(URL)
            .get('/?mes=2&anio=2022')
            .expect(200);
    });

});

// http://20.225.209.57:3031/calendario/get_informacionAsesoria/?idUsuario=A94949494&hora=10&dia=1&mes=6&anio=2022
describe('GET / Infromacion de asesoria de un usuario', () => {

    beforeAll(() => {
        URL += "get_informacionAsesoria"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3031/calendario/'
    });

    //Deberia devolve {}?
    test('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Informacion de asesoria con solo el usuario', async () => {
        await request(URL)
            .get('/?idUsuario=A94949494')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Informacion de asesoria con solo la hora', async () => {
        await request(URL)
            .get('/?hora=10')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Informacion de asesoria con solo el dia', async () => {
        await request(URL)
            .get('/?dia=1')
            .expect(200);
    });
    
    //Deberia devolve {}?
    test('GET Informacion de asesoria con solo el mes', async () => {
        await request(URL)
            .get('/?mes=6')
            .expect(200);
    });

    //Deberia devolve {}?
    test('GET Informacion de asesoria con solo el anio', async () => {
        await request(URL)
            .get('/?anio=2022')
            .expect(200);
    });

    test('GET Informacion de asesoria de A94949494 a la hora 10 del dia 1 del mes 6 del anio 2022', async () => {
        await request(URL)
            .get('/?idUsuario=A94949494&hora=10&dia=1&mes=6&anio=2022')
            .expect(200);
    });

});
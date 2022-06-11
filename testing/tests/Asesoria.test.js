const request = require('supertest')
let URL = 'http://20.225.209.57:3094/asesoria/';

//http://20.225.209.57:3094/asesoria/get_uf/?carrera=ITC&semestre=1
describe('GET / Unidades de formacion', () => {

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

    test('GET con solo carrera', async () => {
        await request(URL)
            .get('/?carrera=ITC')
            .expect(404);
    });

    test('GET con solo semestre', async () => {
        await request(URL)
            .get('/?semestre=1')
            .expect(404);
    });

    test('GET primer semestre de ITC', async () => {
        const response = await request(URL)
            .get('/?carrera=ITC&semestre=1')
        
        expect(response.statusCode).toBe(200);
        expect(response.body.length).toBeGreaterThan(0);
    });

});

//http://20.225.209.57:3094/asesoria/get_dias/?uf=${localStorage.asesoria_uf}&anio=${year}&mes=${month}
describe('GET / Dias disponibles', () => {

    beforeAll(() => {
        URL += "get_dias"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3094/asesoria/'
    });

    //Rompe el microservicio
    test.skip('GET sin parametros', async () => {
        await request(URL)
            .get('/')
            .expect(404);
    });

    //Rompe el microservicio
    test.skip('GET con solo la unidad de formacion', async () => {
        await request(URL)
            .get('/?uf=TC1028')
            .expect(404);
    });

    //Rompe el microservicio
    test.skip('GET con solo el anio', async () => {
        await request(URL)
            .get('/?anio=2022')
            .expect(404);
    });

    //Rompe el microservicio
    test.skip('GET con solo el mes', async () => {
        await request(URL)
            .get('/?mes=5')
            .expect(404);
    });

    test('GET dias desponibles en mayo de 2022 para TC1028', async () => {
        const response = await request(URL)
            .get('/?uf=TC1028&anio=2022&mes=5')
        expect(response.statusCode).toBe(200);
        const days = response.body[Object.keys(response.body)[0]].length
        expect(days).toBeGreaterThan(0);
    });

});

//http://20.225.209.57:3094/asesoria/get_horas/?uf=${localStorage.asesoria_uf}&anio=${anio}&mes=${mes}&dia=${dia}
describe('GET / Horas disponibles', () => {

    beforeAll(() => {
        URL += "get_horas"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3094/asesoria/'
    });

    //deberia devolver []?
    test('GET sin parametros', async () => {
        const response = await request(URL)
            .get('/')
        expect(response.body.horas_disponibles).toHaveLength(0);
    });

    //deberia devolver []?
    test('GET con solo la unidad de formacion', async () => {
        const response = await request(URL)
            .get('/?uf=TC1028')
        expect(response.body.horas_disponibles).toHaveLength(0);
    });

    //deberia devolver []?
    test('GET con solo el anio', async () => {
        const response = await request(URL)
            .get('/?anio=2022')
        expect(response.body.horas_disponibles).toHaveLength(0);
    });

    //deberia devolver []?
    test('GET con solo el mes', async () => {
        const response = await request(URL)
            .get('/?mes=5')
        expect(response.body.horas_disponibles).toHaveLength(0);
    });

    //deberia devolver []?
    test('GET con solo el dia', async () => {
        const response = await request(URL)
            .get('/?dia=3')
        expect(response.body.horas_disponibles).toHaveLength(0);
    });

    test('GET horas para TC1028 el 3 de mayo del 2022', async () => {
        const response = await request(URL)
            .get('/?uf=TC1028&anio=2022&mes=5&dia=3')
        
        console.log(response.body.horas_disponibles)
        expect(response.statusCode).toBe(200)
        expect(response.body.horas_disponibles.length).toBeGreaterThan(0);

    });

});

//http://20.225.209.57:3094/asesoria/nueva
//Rompe el microservicio cuando se solicita una asesoria que ya ha sido registrada
describe.skip('POST / Nueva asesoria', () => {

    beforeAll(() => {
        URL += "nueva"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3094/asesoria/'
    });

    test('POST asesoria con solo la unidad de formacion', async () => {
        const data = {
            uf: 'TC1028'
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test('POST asesoria con solo anio', async () => {
        const data = {
            anio: 2022
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test('POST asesoria con solo mes', async () => {
        const data = {
            mes: 5
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test('POST asesoria con solo dia', async () => {
        const data = {
            dia: 3
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test('POST asesoria con solo hora', async () => {
        const data = {
            hora: 11
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test('POST asesoria con solo duda', async () => {
        const data = {
            duda: 'otra prueba x4'
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test('POST asesoria con solo asesorado', async () => {
        const data = {
            asesorado: 'A01657967'
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test.skip('POST asesoria documentacion', async () => {
        await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(
                {
                    uf: "TC1028",
                    anio: 2022,
                    mes: 3,
                    dia: 15,
                    hora: 10,
                    duda: "otra prueba x4",
                    asesorado: "A01657967"
                }
            )
            .expect(404);
    });

    //Solo se puede ejecutar una vez
    test.skip('POST asesoria unica', async () => {
        const data = {
            uf: 'TC1028',
            anio: 2022,
            mes: 5,
            dia: 3,
            hora: 11,
            duda: 'otra prueba x4',
            asesorado: 'A01657967'
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

});
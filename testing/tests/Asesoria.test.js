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
        
        expect(response.statusCode).toBe(200)
        expect(response.body.horas_disponibles.length).toBeGreaterThan(0);

    });

});

//http://20.225.209.57:3094/asesoria/nueva
//Rompe el microservicio cuando se solicita una asesoria que ya ha sido registrada o solo se manda un dato
describe.skip('POST / Nueva asesoria', () => {

    beforeAll(() => {
        URL += "nueva"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3094/asesoria/'
    });

    test.skip('POST asesoria con solo la unidad de formacion', async () => {
        const data = {
            uf: 'TC1028'
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test.skip('POST asesoria con solo anio', async () => {
        const data = {
            anio: 2022
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test.skip('POST asesoria con solo mes', async () => {
        const data = {
            mes: 5
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test.skip('POST asesoria con solo dia', async () => {
        const data = {
            dia: 3
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test.skip('POST asesoria con solo hora', async () => {
        const data = {
            hora: 11
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test.skip('POST asesoria con solo duda', async () => {
        const data = {
            duda: 'otra prueba x4'
        };

        const response = await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)

        expect(response.statusCode).toBe(200);
    });

    test.skip('POST asesoria con solo asesorado', async () => {
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
            hora: 12,
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

//http://20.225.209.57:3094/asesoria/insertar_imagen/
describe('POST / Insertar imagen', () => {
    
    const fotoB64 = 'data:image/webp;base64,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'

    beforeAll(() => {
        URL += "insertar_imagen"
    });

    afterAll(() => {
        URL = 'http://20.225.209.57:3094/asesoria/'
    });

    test('POST sin parametros', async () => {
        const data = {}
        await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)
            .expect(400);
    });

    //Se puede ejecutar otras 2 veces
    test('POST con datos', async () => {
        const data = {
            idAsesoria: 97,
            imagen: fotoB64
        }

        await request(URL)
            .post('/')
            .set('Content-type', 'application/json')
            .send(data)
            .expect(200);
    });

});
const request = require('supertest')
const baseUrl = 'https://jsonplaceholder.typicode.com/';

describe('Lista de unidades de formacion', () => {

    test('GET / UF de ITC de primer semestre', async () => {
        //const data = await request.get('http://20.225.209.57:3094/asesoria/get_uf/?carrera=ITC&semestre=1')
        await request(baseUrl)
            .get('todos/')
            .expect(200);
    });

    test('GET / UF de ITC de primer semestre content', async () => {
        //const data = await request.get('http://20.225.209.57:3094/asesoria/get_uf/?carrera=ITC&semestre=1')
        const response = await request(baseUrl)
            .get('todos/');
        
            console.log(response.body)
            expect(response.statusCode).toBe(200);
    });
});

80
3000
3014
3090
3091
3092
3093
3094
3095
3030
3031
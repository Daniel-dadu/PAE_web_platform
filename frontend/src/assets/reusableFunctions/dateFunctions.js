const getMonthEspanol = mesEnNumero => 
    mesEnNumero === 0 ? 'Enero' : 
    mesEnNumero === 1 ? 'Febrero' : 
    mesEnNumero === 2 ? 'Marzo' : 
    mesEnNumero === 3 ? 'Abril' :
    mesEnNumero === 4 ? 'Mayo' :
    mesEnNumero === 5 ? 'Junio' :
    mesEnNumero === 6 ? 'Julio' :
    mesEnNumero === 7 ? 'Agosto' :
    mesEnNumero === 8 ? 'Septiembre' :
    mesEnNumero === 9 ? 'Octubre' :
    mesEnNumero === 10 ? 'Noviembre' : 'Diciembre'
    
const monthsEnNumero = {
    Enero: 0,
    Febrero: 1, 
    Marzo: 2,
    Abril: 3, 
    Mayo: 4,
    Junio: 5, 
    Julio: 6, 
    Agosto: 7,
    Septiembre: 8,
    Octubre: 9,
    Noviembre: 10,
    Diciembre: 11
}

const getNameDay = index => 
    index === 0 ? 'Domingo' : 
    index === 1 ? 'Lunes' : 
    index === 2 ? 'Martes' : 
    index === 3 ? 'Miercoles' :
    index === 4 ? 'Jueves' :
    index === 5 ? 'Viernes' : 'Sabado';

const getIndexDay = {
    Lunes: 0,
    Martes: 1, 
    Miercoles: 2,
    Jueves: 3, 
    Viernes: 4
}

module.exports = {
    getMonthEspanol,
    monthsEnNumero,
    getNameDay,
    getIndexDay
} 
import React , {useState} from 'react'
import "./CalendarioMini.css"

function makeCalendarioMini(calendar, year, monthIndex){
    //Almacena todas la semanas del mes en forma de arreglos de dias.
    let  weeks = [[]];
    const enabledDays = calendar[Object.keys(calendar)[0]];

    //Obtiene el ultimo dia del mes anterior
    let lastMontLastDay = new Date(year, monthIndex, 0); 
    //En caso de que el mes anterior haya acabado el la misma semana que el 
    //comienzo del mes agrega los ultimos dias corrrespondiante a la primera semana.
    if(lastMontLastDay.getDay() < 6){
        for(let i = lastMontLastDay.getDate() - lastMontLastDay.getDay(); i <= lastMontLastDay.getDate(); i++){
            weeks[0].push({"day": i, "color": "grey"})
        }
    }

    //Obtiene el ultimo dia del mes actual
    let currentMontLastDay = new Date(year, monthIndex + 1, 0);
    //Agrega los dial del mes al calendario del mes
    for(let i = 1; i <= currentMontLastDay.getDate(); i++){
        let day = {"day": i, "color": "black"};
        for(let j = 0; j < enabledDays.length; j++){
            if(i === enabledDays[j]){
                day = {"day": i, "color": "green"};
                break;
            }
        }
        weeks[weeks.length-1].push(day)
        if((new Date(year, monthIndex, i).getDay() === 6) && i !== currentMontLastDay.getDate()){
            weeks.push([])
        }
    }

    //Agrega lo primeros dias del proximo mes que estan presente en la ultima semana
    if(currentMontLastDay.getDay() < 6){
        for(let i = 1; i < 7 - currentMontLastDay.getDay(); i++){
            weeks[weeks.length-1].push({"day": i ,"color": "grey"})
        }
    }

    return(
        weeks.map((week) =>{
            return(
                <tr>
                    {week.map((day) => {
                        return(
                            <td className='calendario_mini_day' style={{color: day.color}}> {day.day} </td>
                        )
                    })}
                </tr>
            )
        })
    )
}

function CalendarioMini(/* {enabledDays, year, monthIndex, minMonth, maxMonth} */){

    const [today, setToday] = useState(new Date())


    const enabledDays = {"Mayo":[1,2,3,5,20,21,30,31]}, 
            year=today.getFullYear(), 
            monthIndex=today.getMonth(), 
            minMonth=0, 
            maxMonth=4
    /*
    El componente recibe 3 valores.
        -enabledDays: un json con el nombre del mes correspodiante al index como 
        llave, y una lista de los dias habiles.
            Ejemplo:
                {
                    "Abril":
                            [
                                1,
                                2,
                                3,
                                5,
                                20,
                                21,
                                30,
                                31
                            ]
                }

        -year: el año actual.
        -montIndex: El mes que se desea mostrar, por defecto es 0, y no puede 
        ser negativo.
        -minMonth: El primer mes que debe mostrar el minicalendario
        -maxMonth: El ultimo mes que debe mostrar el minicalendario

    Ejemplo:
        enabledDays={info} year="2022" monthIndex={3} minMonth={0} maxMonth={4}
    */

    const[miniCalendario, setMiniCalendario] = useState(makeCalendarioMini(enabledDays, year, monthIndex));
    const[monthName, setMonthName] = useState(Object.keys(enabledDays));

    const[month, setMonth] = useState(monthIndex);
    const goLastMonth = () => {
        if(month > minMonth){
            setMonth(month - 1);
            let test = {"Marzo": [1,3,5,20,21,22,23]};
            setMiniCalendario(makeCalendarioMini(test, year, month -1));
            setMonthName(Object.keys(test));
        }
    };
    const goNextMonth = () => {
        if(month < maxMonth){
            setMonth(month + 1);
            //llamada al back para establecer nuevos enables days
            setMiniCalendario(makeCalendarioMini(enabledDays, year, month +1));
            setMonthName(Object.keys(enabledDays));
        }
    };

    return(
        <div className='calendario_mini_container'>
            <div className='calendario_mini_top'>
                <button type="button" className='buttonArrow' onClick={goLastMonth}><i className="arrow left"></i></button>
                <span>{monthName} - {new Date().getFullYear()}</span>
                <button type="button" className='buttonArrow' onClick={goNextMonth}><i className="arrow right"></i></button>
            </div>
            <table className='calendario_mini_month'>
                <tbody>
                    <tr>
                        <th className='calendario_mini_week_day'>Domingo</th>
                        <th className='calendario_mini_week_day'>Lunes</th>
                        <th className='calendario_mini_week_day'>Martes</th>
                        <th className='calendario_mini_week_day'>Miercoles</th>
                        <th className='calendario_mini_week_day'>Jueves</th>
                        <th className='calendario_mini_week_day'>Viernes</th>
                        <th className='calendario_mini_week_day'>Sabado</th>
                    </tr>
                    {miniCalendario}
                </tbody>
            </table>
        </div>
    )   
}
export default CalendarioMini
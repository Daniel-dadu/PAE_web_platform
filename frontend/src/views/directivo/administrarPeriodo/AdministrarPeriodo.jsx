import React, { useState } from 'react'
import { Template, CampoSeleccionarEnListaDesplegable, BotonSencillo, dateFunctions } from '../../../routeIndex'

import './AdministrarPeriodo.css'

import axios from 'axios'
import { useNavigate } from 'react-router-dom'

function AdministrarPeriodo() {

    const navigate = useNavigate()

    const diasMes = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    const meses = [
        "Enero",
        "Febrero", 
        "Marzo",
        "Abril", 
        "Mayo",
        "Junio", 
        "Julio", 
        "Agosto",
        "Septiembre",
        "Octubre",
        "Noviembre",
        "Diciembre"
    ]
    const anio = new Date().getFullYear()

    // --------- Primer periodo --------- //
    const [Dia1_1, setDia1_1] = useState('')
    const handleDia1_1 = Dia1_1Value => setDia1_1(Dia1_1Value.value)
    const [Mes1_1, setMes1_1] = useState('')
    const handleMes1_1 = Mes1_1Value => setMes1_1(Mes1_1Value.value)

    const [Dia1_2, setDia1_2] = useState('')
    const handleDia1_2 = Dia1_2Value => setDia1_2(Dia1_2Value.value)
    const [Mes1_2, setMes1_2] = useState('')
    const handleMes1_2 = Mes1_2Value => setMes1_2(Mes1_2Value.value)
    // --------- Primer periodo --------- //


    // --------- Segundo periodo --------- //
    const [Dia2_1, setDia2_1] = useState('')
    const handleDia2_1 = Dia2_1Value => setDia2_1(Dia2_1Value.value)
    const [Mes2_1, setMes2_1] = useState('')
    const handleMes2_1 = Mes2_1Value => setMes2_1(Mes2_1Value.value)

    const [Dia2_2, setDia2_2] = useState('')
    const handleDia2_2 = Dia2_2Value => setDia2_2(Dia2_2Value.value)
    const [Mes2_2, setMes2_2] = useState('')
    const handleMes2_2 = Mes2_2Value => setMes2_2(Mes2_2Value.value)
    // --------- Segundo periodo --------- //


    // --------- Tercer periodo --------- //
    const [Dia3_1, setDia3_1] = useState('')
    const handleDia3_1 = Dia3_1Value => setDia3_1(Dia3_1Value.value)
    const [Mes3_1, setMes3_1] = useState('')
    const handleMes3_1 = Mes3_1Value => setMes3_1(Mes3_1Value.value)

    const [Dia3_2, setDia3_2] = useState('')
    const handleDia3_2 = Dia3_2Value => setDia3_2(Dia3_2Value.value)
    const [Mes3_2, setMes3_2] = useState('')
    const handleMes3_2 = Mes3_2Value => setMes3_2(Mes3_2Value.value)
    // --------- Tercer periodo --------- //

    const submitPeriodos = () => {
        if(
            Dia1_1 && Mes1_1 &&
            Dia1_2 && Mes1_2 &&
            Dia2_1 && Mes2_1 &&
            Dia2_2 && Mes2_2 &&
            Dia3_1 && Mes3_1 &&
            Dia3_2 && Mes3_2
        ) {
            const periodo1 = {
                inicio: new Date(anio, dateFunctions.monthsEnNumero[Mes1_1], Dia1_1),
                fin: new Date(anio, dateFunctions.monthsEnNumero[Mes1_2], Dia1_2, 23, 59, 59)
            }
            const periodo2 = {
                inicio: new Date(anio, dateFunctions.monthsEnNumero[Mes2_1], Dia2_1),
                fin: new Date(anio, dateFunctions.monthsEnNumero[Mes2_2], Dia2_2, 23, 59, 59)
            }
            const periodo3 = {
                inicio: new Date(anio, dateFunctions.monthsEnNumero[Mes3_1], Dia3_1),
                fin: new Date(anio, dateFunctions.monthsEnNumero[Mes3_2], Dia3_2, 23, 59, 59)
            }
            console.log(periodo1)
            console.log(periodo2)
            console.log(periodo3)

            const config = {
                method: 'post',
                url: 'http://20.225.209.57:3093/administracion/set_new_periodos/',
                headers: { 
                    'Content-Type': 'application/json'
                },
                data : JSON.stringify({
                    periodo1, periodo2, periodo3
                })
            }
            
            axios(config)
            .then(response => {
                alert(response.data)
                navigate('/administrar')
            })
            .catch(_error => {
                alert("Error: No se pudieron registrar los periodos.")
            })

        } else {
            alert("No se han seleccionado todos los campos")
        }
    }

    return (
        <Template view = "administrar">

            <h2>Establecer las fechas de inicio y fin del semestre</h2>

            <p className='paragraph-instrucciones-periodo-admin'>
                <b>Instrucciones</b>
                <br />
                Seleccione los días y meses en los que empieza y termina cada uno de los periodos que componen al semestre actual.
                <br />
                <br />
                IMPORTANTE: Esta funcionalidad solo se debe usar 1 vez al iniciar el semestre.
            </p>

            <div className='container-select-dates-periodo'>

                <h3>Seleccionar las fechas de inicio y fin del primer periodo:</h3>
                
                <div className='campos-desplegables'>

                    <p>Primer día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={diasMes} parentCallback={handleDia1_1} defaultValue={''}/>
                    <p>Mes del primer día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={meses} parentCallback={handleMes1_1} defaultValue={''}/>

                    <br />

                    <p>Último día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={diasMes} parentCallback={handleDia1_2} defaultValue={''}/>
                    <p>Mes del último día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={meses} parentCallback={handleMes1_2} defaultValue={''}/>
                    {/* <p>Dia: {Dia1_2} </p>
                    <p>Mes: {Mes1_2} </p> */}

                </div>

            </div>

            <div className='container-select-dates-periodo'>

                <h3>Seleccionar las fechas de inicio y fin del segundo periodo:</h3>

                <div className='campos-desplegables'>

                    <p>Primer día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={diasMes} parentCallback={handleDia2_1} defaultValue={''}/>
                    <p>Mes del primer día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={meses} parentCallback={handleMes2_1} defaultValue={''}/>
                    {/* <p>Dia: {Dia2_1} </p>
                    <p>Mes: {Mes2_1} </p> */}

                    <br />

                    <p>Último día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={diasMes} parentCallback={handleDia2_2} defaultValue={''}/>
                    <p>Mes del último día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={meses} parentCallback={handleMes2_2} defaultValue={''}/>
                    {/* <p>Dia: {Dia2_2} </p>
                    <p>Mes: {Mes2_2} </p> */}
                
                </div>

            </div>

            <div className='container-select-dates-periodo'>

                <h3>Seleccionar las fechas de inicio y fin del tercer periodo:</h3>
                
                <div className='campos-desplegables'>

                    <p>Primer día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={diasMes} parentCallback={handleDia3_1} defaultValue={''}/>
                    <p>Mes del primer día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={meses} parentCallback={handleMes3_1} defaultValue={''}/>
                    {/* <p>Dia: {Dia3_1} </p>
                    <p>Mes: {Mes3_1} </p> */}

                    <br />

                    <p>Último día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={diasMes} parentCallback={handleDia3_2} defaultValue={''}/>
                    <p>Mes del último día</p>
                    <CampoSeleccionarEnListaDesplegable size="large" options={meses} parentCallback={handleMes3_2} defaultValue={''}/>
                    {/* <p>Dia: {Dia3_2} </p>
                    <p>Mes: {Mes3_2} </p> */}

                </div>

            </div>

            <div style={{width: 'fit-content', margin: 'auto'}}>
                <BotonSencillo onClick={submitPeriodos} backgroundColor='verde' size='reducido' children='Establecer fechas'/>
            </div>

            
        </Template>
    )
}

export default AdministrarPeriodo
import React, { useState } from 'react'
import axios from 'axios'
import './AgendarAsesoria.css'

import { useNavigate } from "react-router-dom";

import { Template, BarraProgreso, TarjetaMaestraMini, BotonSencillo } from '../../../routeIndex'

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

// Descripción de las propedades
/*
showAtrasBtn: se recibe un booleano que en caso de ser true, muestra el botón de atrás
btnAtrasRoute: se recibe un string con la ruta de la pantalla anterior, es decir, la vista a la que se debe redirigir el usuario al darle al botón de atrás
btnSiguienteRoute:
showTarjetaMaestraMini: se recibe un booleano que en caso de ser true, muestra el contenido de children en la TarjetaMaestraMini
sizeTarjetaMaestraMini: tamaño de tarjeta maestra mini (normal o grande)
progressBarJSON: recibe un JSON con las características de la barra de progreso, es decir, el estado en el que se debe encontrar (revisar documentación del componente BarraProgreso para saber cómo mandarlo)
children: contenido que va dentro

EJEMPLO DE USO:
<AgendarAsesoria showAtrasBtn={false} showTarjetaMaestraMini={true} sizeTarjetaMaestraMini="normal" progressBarJSON={progressBar}>
    <h1>Contenido</h1>
</AgendarAsesoria>

*/

function AgendarAsesoria({showAtrasBtn, btnAtrasRoute, btnSiguienteRoute, showTarjetaMaestraMini, sizeTarjetaMaestraMini, progressBarJSON, children}) {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);
    

    // ****************** Hooks y código usado para la creación de la asesoría en la API ****************** //

    // Hook para guardar la ruta del botón siguente
    const [bodyNewAsesoriaJSON, setBodyNewAsesoriaJSON] = useState('')

    // // Hook usado para conocer el estado de la petición a la API
    // const [newAsesoriaApiState, setNewAsesoriaApiState] = useState({
    //     loading: true, // Booleano que indica si está consultando (cargando) la info de la API
    //     apiData: null // Guarda la información que regresa la API
    // })
    // // Hook usado para indicar el error de la petición a la API, en caso de que ocurra
    // const [errorNewAsesoriaApiCall, setErrorNewAsesoriaApiCall] = useState(null)

    let newAsesoriaApiState = {
        loading: true, // Booleano que indica si está consultando (cargando) la info de la API
        apiData: null // Guarda la información que regresa la API
    }
    let errorNewAsesoriaApiCall = null


    // Hook para hacer la llamada a la API haciendo uso de la función fetch de JS
    const createNewAsesoria = async (body) =>  {
        newAsesoriaApiState = { loading: true }

        let info = JSON.stringify({
            "asesorado": body.asesorado,
            "uf": body.uf
        });

        let config = {
            method: 'post',
            url: 'http://20.225.209.57:3094/asesoria/nueva/',
            headers: { 
              'Content-Type': 'application/json'
            },
            data: info
        };


        try {
            const response = await axios(config)
            console.log(response.data)
            newAsesoriaApiState = { loading: false, apiData: response.data }
            return { loading: false, apiData: response.data }
        } catch (error) {
            newAsesoriaApiState = { loading: false }
            errorNewAsesoriaApiCall = error;
            return { loading: false, apiData: error }
        } 

    }
    
    // // Hook para hacer la llamada a la API haciendo uso de la función fetch de JS
    // const createNewAsesoria = (body) =>  {
    //     setNewAsesoriaApiState({ loading: true })
    //     console.log("body:");
    //     console.log(body)

    //     let info = JSON.stringify( {asesorado: body.asesorado, uf: body.uf} )
    //     console.log(info);

    //     fetch('http://20.225.209.57:3094/asesoria/nueva/', {
    //         method: "POST",
    //         headers: { 'Content-Type': 'application/json' },
    //         body: info
    //     })
    //     //   .then(res => res.json()) // Se indica que la respuesta se regresará en un JSON
    //       .then(
    //         // En caso de que se obtenga la información de la API, se actualiza el carreraApiState
    //         APIdata => {
    //             console.log("uyuyuy")
    //             console.log(APIdata)
    //           setNewAsesoriaApiState({ loading: false, apiData: APIdata })
    //         }, 
    //         // En caso de que haya un error, se actualiza el error
    //         error => {
    //           setNewAsesoriaApiState({ loading: false })
    //           setErrorNewAsesoriaApiCall(error);
    //         }
    //       )
    // }

    // ************************************************************************************************ //

    const onSiguienteClick = (data) => {
        if(data === null || data.uf === null) navigate('/agendarAsesoriaUF/error')

        createNewAsesoria(data).then((data) => {
            console.log("Despues de crear la asesoria:")
            console.log(data)
    
            if(errorNewAsesoriaApiCall || newAsesoriaApiState.loading){
                console.log("Api error")
                navigate('/agendarAsesoriaUF/error')
            } else {
                console.log(newAsesoriaApiState.apiData)
                // navigate('/agendarAsesoriaDuda')
            }
        })
    }    

    return (
        <Template view="agendarAsesoria">
            <div className='container_titleProgress'>
                <h1 className='title_agendarAsesoria'>Agendar asesorías</h1>
                <BarraProgreso progress={progressBarJSON}/>
            </div>

            <div className='container_tarjetaMaestraMini'>
                {showTarjetaMaestraMini ? (
                <TarjetaMaestraMini size={sizeTarjetaMaestraMini}>
                    {children}
                </TarjetaMaestraMini>
                ) : children}
            </div>

            <div className='container_navButtons'>
                {showAtrasBtn ? (
                <div>
                    <BotonSencillo onClick = {typeof btnAtrasRoute === 'string' ? () => routeChange(btnAtrasRoute) : "accionConBackend"} backgroundColor='turquesa' size='normal'>
                        Atras
                    </BotonSencillo>
                </div> 
                ) : null}
                <div className="btn_right">
                    <BotonSencillo onClick = {() => routeChange("./calendario")} backgroundColor='gris' size='normal'>
                        Cancelar
                    </BotonSencillo>
                </div>
                <div>
                    {/* <BotonSencillo onClick={typeof btnSiguienteRoute === 'string' ? () => routeChange(btnSiguienteRoute) : "accionConBackend"} backgroundColor='verde' size='normal'> */}
                    <BotonSencillo onClick={() => onSiguienteClick(btnSiguienteRoute)} backgroundColor='verde' size='normal'>
                        Siguiente
                    </BotonSencillo>
                </div>
            </div>

        </Template>
    )
}

export default AgendarAsesoria
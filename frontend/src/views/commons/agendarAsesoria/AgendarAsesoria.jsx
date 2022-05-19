import React from 'react'
// import axios from 'axios'
import './AgendarAsesoria.css'

import { useNavigate } from "react-router-dom";

import { Template, BarraProgreso, TarjetaMaestraMini, BotonSencillo, imageCompressor } from '../../../routeIndex'

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

// Descripción de las propedades
/*
showAtrasBtn: se recibe un booleano que en caso de ser true, muestra el botón de atrás
btnAtrasRoute: se recibe un string con la ruta de la pantalla anterior, es decir, la vista a la que se debe redirigir el usuario al darle al botón de atrás
btnSiguienteProps: se recibe un objeto que tenga los atributos de view y props. Explicación de lo que deben tener esos atributos:
    - view: En el atributo view se pone un número que corresponda a la vista que está usando ese botón, a continuación se muestran los números y sus equivalencias:
        - 1: AgendarAsesoriaUF
        - 2: AgendarAsesoriaDuda
        - 3: AgendarAsesoriaCalendario
        - 4: AgendarAsesoriaHora
        - 5: AgendarAsesoriaResumen
    - props: En el atributo de props se recibe otro objeto con las variables necesarias para cumplir con la acción que debe hacer dicho botón de Siguiente 
currentIDasesoria: se recibe un entero con el id de la asesoría
showTarjetaMaestraMini: se recibe un booleano que en caso de ser true, muestra el contenido de children en la TarjetaMaestraMini
sizeTarjetaMaestraMini: tamaño de tarjeta maestra mini (normal o grande)
progressBarJSON: recibe un JSON con las características de la barra de progreso, es decir, el estado en el que se debe encontrar (revisar documentación del componente BarraProgreso para saber cómo mandarlo)
children: contenido que va dentro

EJEMPLO DE USO:
<AgendarAsesoria 
    showAtrasBtn={false} 
    btnAtrasRoute="" 
    btnSiguienteProps={{view: 1, props: infoBtnSiguiente}}
    currentIDasesoria={idasesoria}
    showTarjetaMaestraMini={true} 
    sizeTarjetaMaestraMini="normal" 
    progressBarJSON={progressBar}
>
    <h1>Contenido</h1>
</AgendarAsesoria>

*/

function AgendarAsesoria({
    showAtrasBtn, 
    btnAtrasRoute, 
    btnSiguienteProps, 
    currentIDasesoria, 
    showTarjetaMaestraMini, 
    sizeTarjetaMaestraMini,
    progressBarJSON, 
    children
}) {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    // Función que se ejecutará siempre que se de click al botón de Cancelar
    const onCancelarClick = currentIDasesoria => {
        if(currentIDasesoria === -1) {
            navigate("/calendario")
            return
        }
    }

    // Función que se ejecutará siempre que se de click al botón de siguiente
    const onSiguienteClick = (data) => {

        // Se entra en caso de que el botón se ejecute en la view 1 - AgendarAsesoriaUF
        if(data.view === 1) {
            // Si los datos proporcionados no son válidos, se manda el mensaje de error
            if(data.props === null || data.props.uf === null) {
                navigate('/agendarAsesoriaUF/error')
            } else {
                // Se guarda la UF en el localStorage
                localStorage.setItem('asesoria_uf', data.props.uf)
                navigate('/agendarAsesoriaDuda')
            }
        }

        if(data.view === 2) {

            // Missing use of imageCompressor 
            let imagesCompressed = data.props.imagenes.map(img => img.data_url)

            if(data.props.duda === ''){
                if(window.confirm("¿Estás seguro que no quieres escribir una duda?")) {
                    localStorage.setItem('asesoria_duda', '')
                    // No se deben guardar las imagenes en una sola variable ya que los arreglos los guarda como string largo, lo cual no sirve
                    localStorage.setItem('asesoria_imagenes', imagesCompressed)
                    navigate('/agendarAsesoriaCalendario')
                }
            } else {
                localStorage.setItem('asesoria_duda', data.props.duda)
                // No se deben guardar las imagenes en una sola variable ya que los arreglos los guarda como string largo, lo cual no sirve
                localStorage.setItem('asesoria_imagenes', imagesCompressed)
                navigate('/agendarAsesoriaCalendario')
            }
        }
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
                    <BotonSencillo onClick = {() => onCancelarClick(currentIDasesoria)} backgroundColor='gris' size='normal'>
                        Cancelar
                    </BotonSencillo>
                </div>
                <div>
                    <BotonSencillo onClick={() => onSiguienteClick(btnSiguienteProps)} backgroundColor='verde' size='normal'>
                        Siguiente
                    </BotonSencillo>
                </div>
            </div>

        </Template>
    )
}

export default AgendarAsesoria
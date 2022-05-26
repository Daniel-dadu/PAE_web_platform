import React, {useState} from 'react'
// import axios from 'axios'
import './AgendarAsesoria.css'

import LoadingSpin from "react-loading-spin";

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
showTarjetaMaestraMini: se recibe un booleano que en caso de ser true, muestra el contenido de children en la TarjetaMaestraMini
sizeTarjetaMaestraMini: tamaño de tarjeta maestra mini (normal o grande)
progressBarJSON: recibe un JSON con las características de la barra de progreso, es decir, el estado en el que se debe encontrar (revisar documentación del componente BarraProgreso para saber cómo mandarlo)
children: contenido que va dentro

EJEMPLO DE USO:
<AgendarAsesoria 
    showAtrasBtn={false} 
    btnAtrasRoute="" 
    btnSiguienteProps={{view: 1, props: infoBtnSiguiente}}
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
    showTarjetaMaestraMini, 
    sizeTarjetaMaestraMini,
    progressBarJSON, 
    children
}) {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [loadingNext, setLoadingNext] = useState(false)

    // Función que se ejecutará siempre que se de click al botón de Cancelar
    // Elimina todos los campos que se hayan creado en el localStorage
    const onCancelarClick = () => {
        if(window.confirm("¿Estás seguro que quieres cancelar tu asesoría?")) {
            localStorage.removeItem('asesoria_uf')
            localStorage.removeItem('asesoria_duda')
            for(let i = 1; i <= 3; i++) localStorage.removeItem(`asesoria_imagen${i}`)
            navigate("/calendario")
        }
    }

    // Función que se ejecutará siempre que se de click al botón de siguiente
    // Es asincrona ya que para comprimir las imágenes y crear las asesorías se requiere esperar por el resultado 
    const onSiguienteClick = async (data) => {
        
        // Se entra en caso de que el botón se ejecute en la view 1 - AgendarAsesoriaUF
        if(data.view === 1) {

            // Eliminamos la UF (por si usa el botón de atrás)
            localStorage.removeItem('asesoria_uf')
            
            // Si los datos proporcionados no son válidos, se manda el mensaje de error
            if(data.props === null || data.props.uf === null) {
                navigate('/agendarAsesoriaUF/error')
            } else {
                // Se guarda la UF en el localStorage
                localStorage.setItem('asesoria_uf', data.props.uf)
                navigate('/agendarAsesoriaDuda')
            }
        }

        // Se entra en caso de que el botón se ejecute en la view 2 - AgendarAsesoriaDuda
        else if(data.view === 2) {

            // Eliminamos la duda y las imagenes que puedan estar guardadas (por si usa el botón de atrás)
            localStorage.removeItem('asesoria_duda')
            for(let i = 1; i <= 3; i++) localStorage.removeItem(`asesoria_imagen${i}`)

            // Si el usuario no ingresó una duda, se le pregunta si desea continuar
            if(data.props.duda === ''){
                if(window.confirm("¿Estás seguro que no quieres escribir una duda?")) {
                    data.props.duda = ''
                } else {
                    return
                }
            } 

            setLoadingNext(true)

            // OJO: A partir de aquí, todo se está haciendo asincrónicamente (en la vista de 'agendarAsesoriaCalendario')

            // Guardamos la duda ingresada
            localStorage.setItem('asesoria_duda', data.props.duda)

            // Obtenemos el string en base64 de las imágenes
            let imagesBase64 = data.props.imagenes.map(img => img.data_url)

            // Iteramos sobre las imagenes y las insertamos en el localStorage en variables diferentes
            for (let index = 0; index < imagesBase64.length; index++) {
                let result = await imageCompressor(imagesBase64[index])
                // Revisamos si la función de imageCompressor no pudo comprimir la imagen y regresó un error
                if(result.slice(0, 5) === "error"){
                    alert(`Tu ${index === 0 ? 'primera' : index === 1 ? 'segunda' : 'tercera'} imagen es muy grande.\nReduce el tamaño y vuelve a intentarlo`)
                    setLoadingNext(false)
                    return
                }
                localStorage.setItem(`asesoria_imagen${index+1}`, result)
            }

            // Primero navegamos a la siguiente página
            navigate('/agendarAsesoriaCalendario')

        }
        
        setLoadingNext(false)
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
                    <BotonSencillo onClick = {() => onCancelarClick()} backgroundColor='gris' size='normal'>
                        Cancelar
                    </BotonSencillo>
                </div>
                {
                    loadingNext ?
                    <div className='loading_spin'>
                        <LoadingSpin />
                    </div>
                    :
                    <div>
                        <BotonSencillo onClick={() => onSiguienteClick(btnSiguienteProps)} backgroundColor='verde' size='normal'>
                            Siguiente
                        </BotonSencillo>
                    </div>
                }
            </div>

        </Template>
    )
}

export default AgendarAsesoria
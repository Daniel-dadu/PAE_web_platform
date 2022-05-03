import React from 'react'
import './AgendarAsesoria.css'

import { useNavigate } from "react-router-dom";

import { Template, BarraProgreso, TarjetaMaestraMini, BotonSencillo } from '../../../routeIndex'

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

// Descripción de las propedades
/*
showAtrasBtn: se recibe un booleano que en caso de ser true, muestra el botón de atrás
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
                <BotonSencillo onClick = {() => routeChange(btnAtrasRoute)} backgroundColor='turquesa' size='normal'>
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
                <BotonSencillo onClick={() => routeChange(btnSiguienteRoute)} backgroundColor='verde' size='normal'>
                    Siguiente
                </BotonSencillo>
            </div>
        </div>

    </Template>
  )
}

export default AgendarAsesoria
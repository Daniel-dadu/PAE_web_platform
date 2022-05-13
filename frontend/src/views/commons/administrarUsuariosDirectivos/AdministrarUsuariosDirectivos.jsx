import React from 'react'
import '../../../index.css'
import './AdministrarUsuariosDirectivos.css'
import { useNavigate } from "react-router-dom";
import { Template, ListaUsuarios, BotonSencillo} from '../../../routeIndex'

const AdministrarUsuariosDirectivos = () => {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    return(
        <>
        <Template view = "administrar">

            <div className = 'divListaUsuarios'>
                <ListaUsuarios></ListaUsuarios>
            </div>

            <div className = 'btnAtras'>
                <BotonSencillo
                    onClick = {() => routeChange("./AdministrarUsuarios")}
                    backgroundColor = 'turquesa'
                    size = 'normal'
                >
                    Atrás
                </BotonSencillo>
            </div>
            
        </Template>
        </>
    )

};

export default AdministrarUsuariosDirectivos
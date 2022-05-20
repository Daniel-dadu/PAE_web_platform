import React,{useState}  from 'react'
import '../../../index.css'
import './AdministrarUsuariosDirectivos.css'
import { useNavigate } from "react-router-dom";
import { Template, ListaUsuarios, BotonSencillo, BotonConImagen } from '../../../routeIndex'

import { FaCopy} from 'react-icons/fa'


const AdministrarUsuariosDirectivos = (userTypeUsuariosDirectivos) => {

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [active, setActive] = useState(false);
  
    const toggle = () => {
        setActive(!active)
    }
    
    window.toggle = toggle;



    return(
        <>
        <Template view = "administrar">


        {(userTypeUsuariosDirectivos === 'Asesorados') ? 

        <h1> Administrar asesorados </h1>
        
        :

        <div className='btn_AdministrarUsuariosDirectivos'>

        <h1> Administrar asesores </h1>

        <div className='botonCopiarLinkRegistro'>
            <BotonConImagen 
            onClick={'Hola'} 
            backgroundColor='grisClaro'
            size="largo" 
            Image={FaCopy} >
                <div className='textoDeBoton'>Generar Nuevo Link de Registro</div> 
            </BotonConImagen>
        </div>

        </div> 
        
        }
 

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
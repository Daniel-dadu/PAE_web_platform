import React from 'react'
import './PerfilAsesor.css'
import { Template, InformacionPersonalUsuario, BotonConImagen, BotonCambioPerfil, ListaUnidadesDeFormacionAsesor } from '../../../routeIndex'
import { BsBoxArrowInRight } from 'react-icons/bs'

const dataExample = [
  {
      t1 : {
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:1
      },
      t2:{
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:1
      }
  },
  {
      t1 : {
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:2
      },
      t2:{
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:2
      }
  },
  {
      t1 : {
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:3
      },
      t2:{
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:3
      }
  },
  {
      t1 : {
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:3
      },
      t2:{
          claveUF:"TC3005B",
          nombreUF:"Desarrollo de software",
          semestre:3
      }
  }

]

function PerfilAsesor(){

    return(

        <div>

            <Template view = 'perfil'>

                <div className = 'btn_PerfilCommon'>

                    <h1> Administrar perfil </h1>

                    <div className = 'botonCerrarSesion'>
                        <BotonConImagen 
                            onClick = {'Hola'} 
                            backgroundColor = 'grisClaro'
                            size = "grande" 
                            Image = {BsBoxArrowInRight}
                        >
                            Cerrar Sesión
                        </BotonConImagen>
                    </div>

                </div>

                <div className = 'boxPerfilCommon'>
                    <InformacionPersonalUsuario data = {dataExample}> </InformacionPersonalUsuario>
                </div>

                <div className = 'containerBtnCambioTipoUsuario'>
                    <BotonCambioPerfil>
                    </BotonCambioPerfil>
                </div>

                <div className = 'containerListaUFsAsesor'>
                  <ListaUnidadesDeFormacionAsesor>
                  </ListaUnidadesDeFormacionAsesor>
                </div>

            </Template>

        </div>
        
    )

}

export default PerfilAsesor
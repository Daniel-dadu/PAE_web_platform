import React from 'react'
import './PerfilAsesor.css'
import { BotonCambioPerfil, ListaUnidadesDeFormacionAsesor, Perfil } from '../../../routeIndex'

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

        <Perfil>
            <div className = 'containerBtnCambioTipoUsuario'>
                <BotonCambioPerfil />
            </div>

            <div className = 'containerListaUFsAsesor'>
                <ListaUnidadesDeFormacionAsesor data = {dataExample} />
            </div>
        </Perfil>
        
    )

}

export default PerfilAsesor
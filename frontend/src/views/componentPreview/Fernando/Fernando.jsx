import React from 'react'
import { TarjetaInformacion} from '../../../routeIndex'
import info from  '../../asesorado/AgendarAsesoriaResumen/info.json'
//import './Fernando.css'

function Fernando() {
  return (
    <div>
      <TarjetaInformacion info={info}/>
    </div>
  )
}

export default Fernando
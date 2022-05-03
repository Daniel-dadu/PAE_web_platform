import React from 'react'
import { TarjetaInformacion} from '../../../routeIndex'
import info from  './info.json'
//import './Fernando.css'

function Fernando() {
  return (
    <div>
      <TarjetaInformacion info={info}/>
    </div>
  )
}

export default Fernando
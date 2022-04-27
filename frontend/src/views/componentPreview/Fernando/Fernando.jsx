import React from 'react'
import { BarraProgreso } from '../../../routeIndex'
import info from  './progreso.json'

function Fernando() {
  return (
    <div>
      <BarraProgreso progress={info.uno}/>
    </div>
  )
}

export default Fernando
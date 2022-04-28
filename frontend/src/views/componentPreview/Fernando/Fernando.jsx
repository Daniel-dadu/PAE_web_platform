import React from 'react'
import { CalendarioMini } from '../../../routeIndex'
import info from  './calendario.json'

function Fernando() {
  return (
    <div>
      <CalendarioMini calendar={info} year="2022" monthIndex="2"/>
    </div>
  )
}

export default Fernando
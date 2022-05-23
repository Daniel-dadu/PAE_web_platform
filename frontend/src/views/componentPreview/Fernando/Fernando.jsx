import React from 'react'
import { CalendarioMini} from '../../../routeIndex'
import info from  './calendario.json'
//import './Fernando.css'

function Fernando() {
  return (
    <div>
      <CalendarioMini calendar={info} year="2022" monthIndex={3}/>
    </div>
  )
}

export default Fernando
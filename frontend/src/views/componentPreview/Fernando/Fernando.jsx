import React from 'react'
import { CalendarioMini} from '../../../routeIndex'
import info from  './calendario.json'
//import './Fernando.css'

function Fernando() {
  return (
    <div>
      <CalendarioMini enabledDays={info} year="2022" monthIndex={3} minMonth={0} maxMonth={4}/>
    </div>
  )
}

export default Fernando
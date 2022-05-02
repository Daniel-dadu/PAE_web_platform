import React from 'react'
import { CambioMesPeriodo }  from '../../../routeIndex'

function DanielMunive() {
  return (
    <>
    <CambioMesPeriodo dataSupInf={  [ 
  {id: 1,
  Sup: 'Texto Superior 1',
  Inf: 'Texto Inferior 1'},

  {id: 2,
  Sup: 'Texto Superior 2',
  Inf: 'Texto Inferior 2'},

  {id: 3,
  Sup: 'Texto Superior 3',
  Inf: 'Texto Inferior 3'}   ]  } > </CambioMesPeriodo>
    </>
  )
}

export default DanielMunive
import React from 'react'

import btnInfo from './btnInfo'

function BarraLateral() {
    let user = "asesor"

  return (
    <div>
        <div>
            <a href="">
                <img src="" alt="Logo PAE" />
            </a>
        </div>

        <div>
            <div>
                {
                btnInfo[user].buttons.map(
                    (btn) => 
                    <a href="">
                    <img src={btn.image} alt={btn.text} />
                    <p>{btn.text}</p>
                    </a>
                )
                }
            </div>
        </div>

        <div>
            <a href="">
                <img src="" alt="" />
            </a>
            <a href="">
                <img src="" alt="" />
            </a>
        </div>

    </div>
  )
}

export default BarraLateral
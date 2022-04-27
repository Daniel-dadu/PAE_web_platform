import React from 'react'
import "./BarraProgreso.css"

function BarraProgreso(props){
    return(
        <div className='barra_progreso_container'>
            {props.progress.steps.map((step, index) => {
                return <div className='barra_progreso_container'>
                    <div className='barra_progreso_step'> 
                        <div className='barra_progreso_step_circle'> 
                            <div className='barra_progreso_step_outer_circle'></div>
                            <div className='barra_progreso_step_inter_circle'> 
                                <span className='barra_progreso_step_inter_circle_check_mark'>&#10003;</span>
                            </div>
                        </div>
                        <div className='barra_progreso_step_name'> 
                            {step.name}
                        </div>
                    </div>
                    <div className='barra_progreso_path'>
                        <hr className='barra_progreso_path_status'></hr>
                    </div>
                </div>
            })}
        </div>
    )   
}
export default BarraProgreso
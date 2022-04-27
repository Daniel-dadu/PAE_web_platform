import React from 'react'
import "./BarraProgreso.css"

function BarraProgreso(props){
    return(
        <div className='barra_progreso_container'>
            {props.progress.steps.map((step, index) => {
                return <div className='barra_progreso_container'>
                    <div className='barra_progreso_step'> 
                        <div className='barra_progreso_step_circle'> 
                            <div className='barra_progreso_step_outer_circle' style={{backgroundColor: props.progress.currentStep == index || step.state ? "green" : step.next == "refuse" ? "red": step.next == "restricted" ? "orange": "grey"}}></div>
                            <div className='barra_progreso_step_inter_circle'> 
                                {props.progress.currentStep == index ? <span className='barra_progreso_step_inter_circle_check_mark'>&#10003;</span> : null}
                            </div>
                        </div>
                        <div className='barra_progreso_step_name'> 
                            {step.name}
                        </div>
                    </div>
                    {index < props.progress.steps.length-1 ?
                        <div className='barra_progreso_path'>
                            <hr className='barra_progreso_path_status' style={{backgroundColor: step.next == "enable" && props.progress.currentStep > index ? "green" : step.next == "refuse" ? "red": step.next == "restricted" ? "orange": "grey"}}></hr>
                        </div>
                        : null
                    }
                </div>
            })}
        </div>
    )   
}
export default BarraProgreso
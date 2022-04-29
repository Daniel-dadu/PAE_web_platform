import React from 'react'
import "./BarraProgreso.css"

/*
BarraProgresp recibe un json con los datos de los pasos del proceso, con su 
correspondiente estado y paso actual.

-El json es generado por la api.
-La estructura del json es:
    -CurrentStep: Indice del paso actual (el indice comienza por 0)".
    -steps: Lista de pasos que conforma el proceso.
        -step:
            -name: nombre del paso.
            -state: el estado en el cual se encutra el paso, de ser true el paso ya ha sido realizado.
            -next: la posibilidad de avanzar al siguiente paso:
                -enable: es posible avanzar al siguiente paso (color verde).
                -block: no es posible avanzar al siguiente paso si el usuario no cambia su decision (color naranja).
                -refuse: no es posible avanzar al siguiente paso idependientemente de la decision del usuario (colo rojo).
    
    json:
        {
            "currentStep": 0,
            "steps": [
                {
                    "name" : "uno",
                    "state": null,
                    "next": "enable"
                }
            ]
        }
*/

function BarraProgreso(props){
    return(
        <div className='barra_progreso_container'>
            {props.progress.steps.map((step, index) => {
                return index < props.progress.steps.length-1 ?
                    <div className='barra_progreso_container_step_path'>
                        <div className='barra_progreso_step'> 
                            <div className='barra_progreso_step_circle'> 
                                <div className='barra_progreso_step_outer_circle' style={{backgroundColor: props.progress.currentStep == index || step.state ? "green" : step.next == "refuse" ? "red": step.next == "restricted" ? "orange": "grey"}}></div>
                                <div className='barra_progreso_step_inter_circle'> 
                                    {index < props.progress.currentStep ? <span className='barra_progreso_step_inter_circle_check_mark'>&#10003;</span> : null}
                                </div>
                            </div>
                            <div className='barra_progreso_step_name'> 
                                {step.name}
                            </div>
                        </div>
                        <div className='barra_progreso_path'>
                            <hr className='barra_progreso_path_status' style={{backgroundColor: step.next == "enable" && props.progress.currentStep > index ? "green" : step.next == "refuse" ? "red": step.next == "restricted" ? "orange": "grey"}}></hr>
                        </div>
                    </div>
                    :<div className='barra_progreso_container_step_path end'>
                        <div className='barra_progreso_step'> 
                            <div className='barra_progreso_step_circle'> 
                                <div className='barra_progreso_step_outer_circle' style={{backgroundColor: props.progress.currentStep == index || step.state ? "green" : step.next == "refuse" ? "red": step.next == "restricted" ? "orange": "grey"}}></div>
                                <div className='barra_progreso_step_inter_circle'> 
                                    {index < props.progress.currentStep ? <span className='barra_progreso_step_inter_circle_check_mark'>&#10003;</span> : null}
                                </div>
                            </div>
                            <div className='barra_progreso_step_name'> 
                                {step.name}
                            </div>
                        </div>
                    </div>
                
            })}
        </div>
    )   
}
export default BarraProgreso
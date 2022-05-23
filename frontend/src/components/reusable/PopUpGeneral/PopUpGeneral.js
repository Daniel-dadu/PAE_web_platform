import React from 'react';
import { BotonSencillo } from '../../../routeIndex';
import './popUpGeneral.css';

/*

Para usar el componente de PopUpGeneral, se toman en cuanta los properties que se necesitan:

  + tipoPopUpGeneral . El valor default es true, con este se establece si aparece el PopUp sencillo o el grande.
                        ( true -> abre PopUp chico. false -> abre el PopUp grande ).
  + nombreEliminar  . El valor se encuentra por default la de Lupita Lozano, pero podemos mandar cualquier nombre que necesitams.
  + state . Property que se encarga de manejar los cambios y apareciones.
  + function. recibe la funcion que hace que funcione el useState de la parte en donde estamos invocando el componente.

  **Nota: cuando se haga uso de este componente, es importe hacer uso de useState, en el componente o View en donde se quiera usar
          de dicha forma:
           
          const [state, setState] = useState(true); 
          const handleBtn = () => {
            setState(!state);
          }
      
*/

const PopUpGeneral = ( {tipoPopUpGeneral, nombreEliminar, state, funcion} ) => {

  return (
    <>  
        { tipoPopUpGeneral ? (
          <div className={ `contenedorGeneral-PopUpGeneral${state ? ' notActive':''} ` } >

            <div className='contenedor-PopUpGeneral'>
                <div className='parte-arriba-PopUpGeneral'>
                    <p className='texto-PopUpGeneral'> Tu reserva se realizó exitosamente </p>
                </div>
                <div className='parte-abajo-PopUpGeneral'>
                    <BotonSencillo onClick={ funcion } backgroundColor="verde" size="normal"  children="Entendido" />
                </div>
            </div>
          </div>
        )
        :
        (
          <div className={ `contenedorGeneral-PopUpGeneral${state ? ' notActive':''} ` } >
            <div className='contenedor-PopUpGeneral-2'>

              <div className='parte-arriba-PopUpGeneral-2'>
                    <b className='texto-encabezado-PopUpGeneral'> ¿Estas seguro? </b>
                    <br/>
                    <p className='texto-PopUpGeneral-2'> ¿Estas seguro que deseas eliminar a “{ nombreEliminar }”? Una vez que la elimines no podras desacerlo </p>
              </div>
              <div className='parte-abajo-PopUpGeneral-2'>
                    <BotonSencillo onClick={ funcion } backgroundColor="gris" size="normal"  children="Cancelar" />
                    <BotonSencillo onClick={ funcion } backgroundColor="negro" size="normal"  children="Eliminar" />

              </div>

            </div>
          </div>
        )}      
    </>
  )
}

export default PopUpGeneral
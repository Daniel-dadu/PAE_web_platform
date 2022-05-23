import * as React from 'react';

export const useIsOverflowX = (ref, callback) => {

  //Custom hook para poder calcular si una etiqueta elemento referenciado se desborda en el eje X, es decir verticalmente.
    

  //se usa un useState para poder calcular el cambio de los estados, se inicializa en false, por el hecho 
  //de que el contenedor al inicio no se esta desbordando. 
  const [isOverflow, setIsOverflow] = React.useState(false);


  //se usa useLayoutEffect para poder volver a renderizar un elemento DOM.
  React.useLayoutEffect(() => {

    const { current } = ref;
    
    const trigger = () => {
      const hasOverflow = current.scrollHeight > current.clientHeight;

      setIsOverflow(hasOverflow);

      if (callback) callback(hasOverflow);
    };

    if (current) {
      trigger();
    }
  }, [callback, ref]);

  return isOverflow;
};

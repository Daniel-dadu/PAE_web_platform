import React, { Component } from 'react'
import Portal from './Portal'

export default class modal extends Component {
  render() {

    const { children, toggle, active } = this.props;



    return (
      <Portal>
          {active && (
              <div>
                  <div>
                      <button style={styles.closeBtn} onClick={toggle}> Salir </button>
                      <div>{children}</div> 
                  </div>
{/*                   <div onClick={toggle} style={styles.background}/> */}
              </div>

              
          )}

      </Portal>
    )
  }
}


const styles = {


    closeBtn: {
        position: 'relative',
        top: 0,
        right: 0,
        background: 'red',
    },

    background: {
        position: 'absolute',
        width : '100%',
        height: '100%',
        top: 0,
        left: 0,
        background: '#000',
        opacity: 0.4,
    }
}
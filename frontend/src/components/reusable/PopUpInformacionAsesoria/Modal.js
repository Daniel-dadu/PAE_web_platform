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
                      <div>{children}</div> 
                  </div>
                  <div style={style.background} onClick={toggle} />
                  
              </div>

              
          )}

      </Portal>
    )
  }
}

const style = {
    background: {
        position: 'absolute',
        width: '100%',
        height: '100%',
        top: '0',
        left: '0',
        background: '#000',
        opacity: '0.4',
        zIndex: 1},
}
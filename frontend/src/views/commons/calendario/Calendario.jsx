import React, { useState, useEffect } from 'react'
import { Template, CambioMesPeriodo, ComponenteCalendario, PopUpInformacionAsesoria, dateFunctions } from '../../../routeIndex'
// import asesoriaJSON from './PruebaCommonCalendario.json'
import './CalendarioStyle.css'
import  Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal';
import { useNavigate } from "react-router-dom"
import axios from 'axios'

var informacionAsesoria = {
  "nombreUF": '',
  "idAsesorado": '',
  "hora": 0,
  "dia": 0,
  "mes": 0,
  "anio": 0
}

// Importante: es necesario revisar cómo se va a manejar el tema e idioma de la BARRA LATERAL. Aquí está hardcodeado

function Calendario(){

  const navigate = useNavigate();
  
  // Si se intenta ingresar a esta vista pero no se cuenta con el localStorage.usuario, se redirige a /landingPage
  useEffect(() => {
    if(!localStorage.usuario){
        localStorage.clear()
        navigate('/landingPage')
        return
    }
  }, [navigate])

  const [calendarioJSON, setCalendarioJSON] = useState({});
  const [asesoriaJSON, setAsesoriaJSON] = useState(
    {
      "hora": 0,
      "dia": 0,
      "mes": 0,
      "anio": 0,
      "usuario": "",
      "duda": "",
      "images": [],
      "status": ""
    }
  );

  // Variable para conocer la fecha de hoy y actualizar el año
  const [today, setToday] = useState(new Date())

  // Variable de tipo objeto para actuazlizar los valores del mes y año
  const [mesAnio, setmesAnio] = useState(
    {
      mes: dateFunctions.getMonthEspanol(today.getMonth()),
      anio: today.getFullYear()
    }
  )

  // Función que maneja se ejecuta cuando se da click a una flecha del componente CambioMesPeriodo
  // Recibe como parámetro el tipo de botón al que se le dió click y cambia el valor de 'mesAnio' y 'today'
  const handleArrowClick = arrow => {
    let currentMonth = mesAnio.mes
    if(currentMonth === 'Diciembre' && arrow === 'next') {
      setmesAnio(
        {
          mes: 'Enero',
          anio: today.getFullYear()+1
        }
      )
      setToday(new Date(today.getFullYear()+1, today.getMonth(), today.getDate()))
    } else if (currentMonth === 'Enero' && arrow === 'back') {
      setmesAnio(
        {
          mes: 'Diciembre',
          anio: today.getFullYear()-1
        }
      )
      setToday(new Date(today.getFullYear()-1, today.getMonth(), today.getDate()))
    } else {
      setmesAnio(
        {
          mes: dateFunctions.getMonthEspanol(
            arrow === 'next' ? dateFunctions.monthsEnNumero[currentMonth]+1 :
            dateFunctions.monthsEnNumero[currentMonth]-1
          ),
          anio: today.getFullYear()
        }
      )
    }

    handleSubmit()

  }

  const [active, setActive] = useState(false);
  
  const toggle = (hora, dia, mes, anio) => {

    if(hora !== undefined && dia !== undefined && mes !== undefined && anio !== undefined){

      var config = {
          method: 'get',
          url: `http://20.225.209.57:3031/calendario/get_informacionAsesoria/?idUsuario=${localStorage.usuario}&hora=${hora}&dia=${dia}&mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}`,
          headers: {}
      };
      
      axios(config)
      .then(function (response) {
          // console.log(JSON.stringify(response.data));
          // console.log(JSON.stringify(response.data))
          setAsesoriaJSON(response.data);

          informacionAsesoria["nombreUF"] = response.data.uF;
          informacionAsesoria["idAsesorado"] = (localStorage.rolUsuario === 'asesor') ? response.data.usuario.substring(response.data.usuario.length-9, response.data.usuario.length) : localStorage.usuario;
          informacionAsesoria["hora"] = response.data.hora;
          informacionAsesoria["dia"] = response.data.dia;
          informacionAsesoria["mes"] = response.data.mes;
          informacionAsesoria["anio"] = response.data.anio;

          console.log(JSON.stringify(informacionAsesoria))

      })
      .catch(function (error) {
          console.log(error);
      });

    }
    else{
      setAsesoriaJSON(
        {
          "hora": 0,
          "dia": 0,
          "mes": 0,
          "anio": 0,
          "usuario": "",
          "duda": "",
          "images": [],
          "status": ""
        }
      );
    }

    setActive(!active)

  }
  
  window.toggle = toggle;

   // Hook para hacer la llamada a la API haciendo uso de la librería axios de JS
  useEffect(() => {
        
    var config = {
        method: 'get',
        url: (localStorage.rolUsuario === "directivo") ? `http://20.225.209.57:3031/calendario/get_allAsesorias/?mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}` : `http://20.225.209.57:3031/calendario/get_asesorias/?idUsuario=${localStorage.usuario}&mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}`,
        headers: {}
    };
    
    axios(config)
    .then(function (response) {
        // console.log(JSON.stringify(response.data));
        setCalendarioJSON(response.data);
        // console.log(JSON.stringify(response.data))
    })
    .catch(function (error) {
        console.log(error);
    });

  }, [setCalendarioJSON, mesAnio])

  // Función que se ejecuta al darle click al botón de ingresar
  const handleSubmit = async e => {
    e.preventDefault()

    // Características de petición a la API
    let config = {
        method: 'get',
        url: (localStorage.rolUsuario === "directivo") ? `http://20.225.209.57:3031/calendario/get_allAsesorias/?mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}` : `http://20.225.209.57:3031/calendario/get_asesorias/?idUsuario=${localStorage.usuario}&mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}`,
        headers: {}
    }

    // Se realiza la consulta a la api en un try catch para manejar errores
    try{
        // Se pide la consulta a la API exigiendo que se ejecute la promesa en ese momento
        const response = await axios(config)
        setCalendarioJSON(response.data)
    } catch (error) {
        alert(error)
    }

  }

  const cancelarAsesoria = () => {

    const config = {
        method: 'post',
        url: 'http://20.225.209.57:3030/notificacion/cancelarAsesoria',
        headers: { 
            'Content-Type': 'application/json'
        },
        data: JSON.stringify({
            "nombreUF": informacionAsesoria["nombreUF"],
            "idAsesorado": informacionAsesoria["idAsesorado"],
            "hora": informacionAsesoria["hora"],
            "dia": informacionAsesoria["dia"],
            "mes": informacionAsesoria["mes"],
            "anio": informacionAsesoria["anio"]
        })
    }
    
    axios(config)
    .then(response => {
        
        alert("Bien, " + response.data)

        var config = {
            method: 'get',
            url: (localStorage.rolUsuario === "directivo") ? `http://20.225.209.57:3031/calendario/get_allAsesorias/?mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}` : `http://20.225.209.57:3031/calendario/get_asesorias/?idUsuario=${localStorage.usuario}&mes=${dateFunctions.monthsEnNumero[mesAnio.mes]+1}&anio=${mesAnio.anio}`,
            headers: {}
        };
        
        axios(config)
        .then(function (response) {
            // console.log(JSON.stringify(response.data));
            setCalendarioJSON(response.data);
            // console.log(JSON.stringify(response.data))
            setActive(!active)
        })
        .catch(function (error) {
            console.log(error);
        });

    })
    .catch(error => {
        alert("Error: " + error.response.data)
    });
  }

  return(
    <>

    <Template view="calendario">
      <div className='container_titleCalendar'>
          <h1 className='title_calendario'>Próximas asesorías</h1>
          <div className='mesAno_style'>
            <CambioMesPeriodo dataSupInf={{textoSuperior: mesAnio.mes, textoInferior: mesAnio.anio}} onClickArrow={handleArrowClick} />
          </div>   
      </div>

      <Modal active={active} toggle={toggle}>
        <PopUpInformacionAsesoria  userTypePopUpAsesoria = {(localStorage.rolUsuario === "directivo") ? localStorage.rolUsuario : 'alumno'} infoAsesoria = {asesoriaJSON} estado={toggle} accionCancelar = {() => {cancelarAsesoria()}}/> 
      </Modal>


      <div className='calendarioStyle'> 
        <ComponenteCalendario
          userTypeCalendario = {(localStorage.rolUsuario === "directivo") ? localStorage.rolUsuario : 'alumno'}
          diasCalendario = {calendarioJSON}
          sizeCalendario = 'grande'
          mes = {mesAnio.mes}
          anio = {mesAnio.anio}
        />
      </div>
    </Template>

  </>
  )
}

export default Calendario
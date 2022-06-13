import React, {useState, useEffect} from 'react'
import './AsesoriasExistentesDiaDirectivos.css'
import { useNavigate, useParams } from "react-router-dom";
import Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal.js'
import { Template, BotonSencillo, ListaDesplegable, PopUpInformacionAsesoria, dateFunctions } from '../../../routeIndex'
import axios from 'axios'

var informacionAsesoria = {
    "nombreUF": '',
    "idAsesorado": '',
    "hora": 0
}

var nombreAsesor;

function AsesoriasExistentesDiaDirectivos(){

    const { dia, mes, anio } = useParams();
    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);
    const [asesoriasIndividuales, setAsesoriasIndividuales] = useState({
        "asesores": []
    });

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

    const [active, setActive] = useState(false);
  
    const toggleIndividual = (hora, matriculaAsesor, nombreAsesorC) => {

        if(hora !== undefined && matriculaAsesor !== undefined){

            nombreAsesor = nombreAsesorC + ' - ' + matriculaAsesor;
    
          var config = {
              method: 'get',
              url: `http://20.225.209.57:3031/calendario/get_informacionAsesoria/?idUsuario=${matriculaAsesor}&hora=${hora}&dia=${dia}&mes=${mes}&anio=${anio}`,
              headers: {}
          };
          
          axios(config)
          .then(function (response) {
              // console.log(JSON.stringify(response.data));
              // console.log(JSON.stringify(response.data))
              setAsesoriaJSON(response.data);
    
              informacionAsesoria["nombreUF"] = response.data.uF;
              informacionAsesoria["idAsesorado"] = response.data.usuario.substring(response.data.usuario.length-9, response.data.usuario.length);
              informacionAsesoria["hora"] = response.data.hora;
    
              // console.log(JSON.stringify(informacionAsesoria))
              
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

    window.toggleIndividual = toggleIndividual;

    useEffect(() => {
        
        var config = {
            method: 'get',
            url: `http://20.225.209.57:3031/calendario/get_asesoriasIndividuales/?dia=${dia}&mes=${mes}&anio=${anio}`,
            headers: {}
        };
        
        axios(config)
        .then(function (response) {
            // console.log(JSON.stringify(response.data));
            setAsesoriasIndividuales(response.data);
            // console.log(JSON.stringify(response.data))
        })
        .catch(function (error) {
            console.log(error);
        });
    
    }, [setAsesoriasIndividuales, dia, mes, anio])

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
                "dia": dia,
                "mes": mes,
                "anio": anio
            })
        }
        
        axios(config)
        .then(response => {
            
            alert("Bien, " + response.data)
    
            var config = {
                method: 'get',
                url: `http://20.225.209.57:3031/calendario/get_allAsesorias/?mes=${mes}&anio=${anio}`,
                headers: {}
            };
            
            axios(config)
            .then(function (response) {
                // console.log(JSON.stringify(response.data));
                // setCalendarioJSON(response.data);
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

        <div>

            <Template view = 'calendario'>

                <Modal active = {active} toggle = {toggleIndividual}>
                    <PopUpInformacionAsesoria  userTypePopUpAsesoria = {(localStorage.rolUsuario === "directivo") ? localStorage.rolUsuario : 'alumno'} infoAsesoria = {asesoriaJSON} estado={toggleIndividual} accionCancelar = {() => {cancelarAsesoria()}} nombreAsesor = {nombreAsesor}/>
                </Modal>

                <h1> Asesorías por asesor - {dia} de {dateFunctions.getMonthEspanol(mes-1)} del {anio} </h1>

                {
                    Object.keys(asesoriasIndividuales['asesores']).map((index) => {
                        return(
                            <>
                            <div className = 'containerListaDesplegableAsesorias'>
                                <ListaDesplegable
                                    fecha = {asesoriasIndividuales['asesores'][index]['nombreAsesor']}
                                    tipo = {2}
                                    arrContenido = {asesoriasIndividuales['asesores'][index]['asesorias']}
                                />
                            </div>
                            </>
                        )
                    })
                }

                <div className = 'btnAtras'>
                    <BotonSencillo
                        onClick = {() => routeChange("./calendario")}
                        backgroundColor = 'turquesa'
                        size = 'normal'
                    >
                        Atrás
                    </BotonSencillo>
                </div>

            </Template>

        </div>
        
    )

}

export default AsesoriasExistentesDiaDirectivos
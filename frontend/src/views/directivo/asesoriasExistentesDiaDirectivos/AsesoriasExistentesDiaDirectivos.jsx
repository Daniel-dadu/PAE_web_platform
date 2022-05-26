import React, {useState} from 'react'
import './AsesoriasExistentesDiaDirectivos.css'
import { useNavigate } from "react-router-dom";
import Modal from '../../../components/reusable/PopUpInformacionAsesoria/Modal.js'
import { Template, BotonSencillo, ListaDesplegable, PopUpInformacionAsesoria } from '../../../routeIndex'

var asesoriasJSON = {
    "listaGrande": [
        {
            "claveUF":"TC3005B",
            "colorTipo3":"verde_tipo3",
            "horaAsesoria":"11 AM",
            "contenido":"Ezequiel Lozano Guerrero le dará asesoria a Daniel Maldonado Espitia"
        },
        {
            "claveUF":"TC3005B",
            "colorTipo3":"rojo_tipo3",
            "horaAsesoria":"11 AM",
            "contenido":"CANCELADA"
        },
        {
            "claveUF":"TC3005B",
            "colorTipo3":"verde_tipo3",
            "horaAsesoria":"11 AM",
            "contenido":"Ezequiel Lozano Guerrero le dará asesoria a Daniel Maldonado Espitia"
        },
        {
            "claveUF":"TC3005B",
            "colorTipo3":"verde_tipo3",
            "horaAsesoria":"11 AM",
            "contenido":"Ezequiel Lozano Guerrero le dará asesoria a Daniel Maldonado Espitia"
        }
    ]
}

function AsesoriasExistentesDiaDirectivos(){

    let navigate = useNavigate()
    const routeChange = route => navigate(`/${route}`);

    const [active, setActive] = useState(false);
  
    const toggleInformacionAsesoria = () => {
        setActive(!active)
    }
    
    window.toggleInformacionAsesoria = toggleInformacionAsesoria;

    return(

        <div>

            <Template view = 'calendario'>

                <Modal active = {active} toggle = {toggleInformacionAsesoria}>
                    <PopUpInformacionAsesoria  userTypePopUpAsesoria = "alumno" estado = {toggleInformacionAsesoria} infoAsesoria = {
                        {
                            "5": {
                                "numeroDia": "5",
                                "mes": "Abril",
                                "asesorias": [
                                    {
                                        "status": "Activa",
                                        "hora": "09:00",
                                        "openPanel": "() => {toggle()}",
                                        "asesor": "Danie Maldonado",
                                        "asesorado": "Lozanosoft",
                                        "lugar": "Biblioteca Norte",
                                        "uF": "Fundamentos químicos",
                                        "duda": "Aquí debe ir mucho texto que describa la duda que tiene el alumno y debe estar escrita de la forma más específica posible. Entre más texto escriban debe ser mejor para los asesores. Aquí debe ir mucho texto que describa la duda que tiene el alumno y debe estar escrita de la forma más específica posible. Entre más texto escriban debe ser mejor para los asesores.",
                                        "images" : [ "data:image/png;base64,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", 
                                            "data:image/png;base64,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",
                                            "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAABNCAYAAAD3nHdRAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAA2pSURBVHgB7VwJcFXVGf7PXV9CIrsioCwGsg4IOgIqFqV2tCjkkQanBatWZKRutaN1rEyJtDpqa7VVa13aad2qIklIKUK1IFZFVKqErG6ERSAaAmQhb7v39P/fvZecXF/Cvcl7CjP5Mv+8c84923+W//znnP+EQYrxCVyq80DatJjJR0qm0Zgdq3hjDxQPboQWfQ3MaFwOJZwBcEgxGKQINXrRBMbNq4HxRVjM6WAxw/GvHX/XM8YHc84GcMYHMs4+4txcp0WldVlQ9iWkAElntEa/DBlUlyFXcxmDQeAPezHdSuDmZjD56eGY9NQUKD8ESUDSGF2LQ3Scrl+HvfQQMqhAEoBMr5GM2EOVsc/eWgA1EegDksJonRK8iEv815jbDMyypzxbkCSMsw/ZCCEj6Rh5OIad1G0KDlEc3u9oKluQ1db7Yd0nRrGirF77wVwOxguYU3o3BTThxHzGUNTf5rd/1QSw0WA4cTvzKJG2pX1wqmbI5zMmXYvfZmL8QILSdsiczZkYKauFXqBPjNao8xZLTPojis20BJ8551AmScptOaGVO8Aj6tXgZC7Bg9gSsxN83hNifOaUUHkD+ESvGa1JLyxkMfYPzKFL62MF90km3CVH01dNgOdboBeogmJN1qP3YvVuhfhQ71LhKiUMs/1K514xWpsZHMoisA2ZGuX6dNhkvCg/VP4fSALqAvOX4bKzwj3vsdyn88Jl14EPSNAL8Ahf4WIyLAF7lGUapyWLScK+UPN9WMXH3OHI9eIqJXg++IDnHqWMX4lNfmdhRvXQWDS2E4Pi8xIFRzvI0hV5R0r/BSnADigc1BGQ1jHOp7k+bdweVi5eACsNL/l47lFZ4XsWwhYVmVwGNpPYTI2mwS5JFZOEcagwSDH+SyEoir3zCjbwaePhYIbXfDwzmouSzgwE7kDnzXZQG+PGkoJY2VuQYuTEyjZgRV8jN61LBo+VAJd+MRDUkNc8PGswH8AS1eBfLmb2aMeCf5UdrqgAn+CoQdXogWswl4uQMnER2o95lg+KZLw+Ap5t7y6dgXEY8IsxjSoxZUNAhjMPRjpoZIW9lOupR2u0YEGG2rgIK3Qa+XG5b24NR58An6jRg7fWa4GvMD0yyv4LTL4/JitP4TBUDuht19br877bXVoDzPXA2WFyc2AntRiQpgeGDASP8NSj0cEZO9RDrQ8flVyMvXs2rDkCPlAbCN4NJtxgMH4FLg3rRO3IwUdpxaNwDR1RACv3u78VhMs/r9WDTViHgUitEsQkNT3aBB4HrydG0xubZEMLnMstTqM4Du4FH/hECc6IclgYkthZU0NlO7sT9md2rPyiuzxoz1qDSys6z8ARMJwb2uis5orPwCM8Dd2wmjbfUfOwkE05HaVvg0fsgeBQQ4bn0Ll0aqh0J/QJLCI42/xs2D0xKklm577ShFLwgTaVF+Kc2onD9TXoKxiPOk6FyTeBD3hi1DR5m+NGhbsBPILDLIVLbKFswkvgA/syiofvGFA8wh2Os/poffGE4l3wAU+MMgnko25TagSPqA5kjMTKTefcqAEfaGvTwuH2cIKlhmVav7yBmewd8AFPwgj1WNVxB7TYFxAFT5C5GqC5bYLsa/OQaNcT3/tam3UEq/gsGqoDH/A2dKlP7fKOtOsHwSMYU0hdM5nMz/aaZjcUpxG5w7fCZWnIZHa8Ppy/Pw4intU/grehC44Q4EdwjfN8dtOmdrTiz17sjkle4lOvhdVoXvuwzK+NtAxNnYM/OSj1G3lELT8ZRngcVxY8Mio5BXvaKTg4u3VNE0oQXIp4cD9cOeBY8Wm54IrUmNP011YxnDQzE+AvVhz2QD7kH2mGZk+qnwNPjPKjDOI5rM/NOjPlFxljAw5qbTclyJdVa4UL6vTg9TthzmAKm9BRuidBBabi1jsT5/syFYyKrbBXngCv+mLUU6WrteBCicUXfTBMPqUgWv6Rl3S1qCygFJNjOjyJa+lsxmPn5UQqKt3xXoZiubt9Za0WnI9MPoGNonHGJuWh0oHDlyVSIXuCtx7l/BPHrUrwE/AIU5VOD2l8pgnR2zGXrRzkjdXq3CnueImYrM+8bFh1oLAEnS8hRzGcPBfk2ZqVXyYJnhgdGFW3Y/bxyW/6OH3Jj676EBmsNbk2WTaVn6HsrpQYMqvPuzmRZCVQb9WphUvNsLJZ4mw5clWJesIF2e1l26AP8DzfcItVg5FzsSbVuZGyAvCJWr3ocm7yU0DiZ2E+12PRu3CZ+JsEvBIX/3bUdIYbEpuJ32YBLaUA+/H45DE4yfxDTlNFK/QR3s+M9MKnZWDX4lntIU02J2V1rN4NPkCC52O96FLcV85Cb5bE8IiNs3x0jwHagNNgAYZaF6/CgblJk9hz4/u8CeiEjx6dPwfX0zVWIr4WxcEDuaGyTeATVcOLM7TDse/FULjIHDRT5rtQAzigMSWEc/pQVtvLTb2Zg8eCZ0brYG4m6DLOFxgbD+C8BXulKDu8+nXoJT4cVDgoPQwTMS/dAHlXbqh0V6ruSn2tidV64SOo995oe0m9u+3F8ORHS6DEhOMcvg6weThyD4vPpThUXHYGnwhMEnwxWgBr95tgPun4UeO5g2624QSA7ysJWdJ+gz9N5MbJpOPdyDlwAsA3o9nxAyy2wkmPO81raJGH4xy9umTKCU+iix/n5Hx2nV50Ixzn6HVP1OnFuAk21mJvjkdumxW8jZ4QLfV1jvNNok9D7mO1aJoh8VXYr6Mwo45wOGP45B6uFb5N9GroOpgYXbUFe3UpOltxCKdpWtsTlfa+8nhDUoRIVSB4kWyyUiDjKIAGk4Vn5YXWJk1PTQb61KMOCkJlGxQZLgHLIGos4/rbtfq8y+E4QlIYJeARyLsxSZ+OWsSb6B2FO5PlVcr8846XpSfplaDtWF2g8CrkjxSLIZxOKg1YkRdLwpVEH5Cy1t49ujit9UDsRmbCT3EPOwxP62/Ji7Y8w+CNGHwLSPmwIsuwurRt07jJFuCR4Kn4W6/gvYkalmrGQeq2ZW584/OHGN88ulofEgor2U2r21Kxye5HP/rRj370ox/JxbeucMetrbVoUXskttqvNZof9LR7IduiXKQfIy0C7zgZaSoSmYlf1VNEuvxVtNizuON5YYCuPgApRE+MfgeJLnz/jjQRvIFGyJ+AjEEBfo80pKfIR9K0C3ETt8D2Lq1Lm38epAg9MboZybmuawNvIL31n9A5JXo0ScztKMNTCVhON3R43H+DH9M7v+jJzogq6VigdIB3iIaIx7QzUEKh+w0tvTwnvKoSUoieGKXrdmdn4ee5lChQjpkubnQRAWLSGQW93c2Q0Ve3JjnO0CUTOBIeeBUfv24gMzg6EjnF/i5ulknYPIS0C4mONvcilSOdYX8XCyP3mUivIh1Aqke6CzqZGo90J1hyoM4OJyIDrEfAkhFku0sP8eiwje5nzxXyH4p0N9ILSB8j0Ruc3yHtA2vakTlAkROZMqZ5xW36FGmjHdEJc6QnvSOrscPeQ3oYrKFKfnpwQ9ZcBUI6sr9vEPwO3QOdDdxshzlPsTSwGtuJS/KhRfAfEBqVUGWHUz7PgzUSI0J8csftJeYJgbcJGWQJBV5phz1u+z+wK0kYiXTQDi9Byhfyox6h3iarr2XQOR1ozg+z079th20VyiaJ/SDQIwlr1FFnLAHrypLi3i7EfcYOI5lCPT7QZuwpoR5jKOLVtoe6WZyzNGy/sr8tshM32v6fQ1eU2uH0uCdPKKAB6VQh3krh20I77FXb/74QL5GdH/X0bjvuk0L440Ke4tuYc4TwseLy8m/oOhedlgQ7MjFwsu1/z1UJx7R1tCuc5vk+wS9WMMv+DQtlOBCXM6qDI2jahbo5EAWeaPHZxZJF7EH3c0WRUUKu4P4hkvii4Sz7NwBdK/GpK896we28GXUa131zPhNpMdJ0pAH295EJ4jrGWNRQLQnC4xAZdS8F7h4V71SWwNdBFQ65KuE2eW1PUBFTKAPsMmmO3mLHwfuduPJC9SsESyCKZXChfHFUdGk4kVH3q1yRUQZdG4LmqHv4Eg5D1x51Kwyy4D4g5C1WjITZzXY4lUMqpdMoM8BiVGTISd+j5anIaK7rmy5UjH4bhG8kyrdAYuRB9zhFcG931cGp/BVgNRatz48I8WlaZLriAnh9ACG4L3Z9c8Q0gZimOewMvVnQPXra+k22f0lQbLTdiivdGPvXfaJPRiFfe1AAvWCUzLjnCP4ZQiWoJcmO1nkEQEtDTjd5sm7yp1HhPG5dB536s/Oi2LHbdwQKSfCxQnoSTHqCMhQhf0gQftTzueCnxXctWOP9QrDmGGVOqhYNF3ptuAGsnl6PRLYMpFWRfksNRY9XVwv5ORWjhiKF4QKwlqI7hTiObHDWTnqieQNYjUR1oXWW/mEFaVyk5tGWUXxurQq8MOgc1jq44Eg5R+tw6D6wepHc4qMe6hVRJTOhU+N5Gely4RvF2wGdGhb9TneV75TRCp0C8H1XXSj/74MlAMm/Xki/Sogn/ueAmUL4WKe76UqP1Dp6zkzSkKxM/gyWmkYqGvXCJjvR/8CybydhQRKQFnKStm8gPQqWhkULN+WdaVec0tM14o/A2gw4oPWRli3quS12oxyyK0/yYIydL63bb9nxKX96w/am3ci5dhxKvx06hz4pN6RJkba28f8cc8pDSiN0gAAAAABJRU5ErkJggg=="
                                        ]
                                    }
                                ]
                            }
                        }}
                    >
                    </PopUpInformacionAsesoria>
                </Modal>

                <h1> Asesorías existentes </h1>

                <div className = 'containerListaDesplegableAsesorias'>
                    <ListaDesplegable
                        fecha = '7 de marzo del 2022'
                        tipo = {2}
                        arrContenido = {asesoriasJSON.listaGrande}
                    />
                </div>

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
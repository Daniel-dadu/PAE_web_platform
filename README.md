# PAE web platform - Devsoft
Plataforma de asesorías para el Programa Asesor Estudiante del Tec de Monterrey Campus Puebla

## Indice
- [Estructura del proyecto](#estructura-del-proyecto)
- [Crear un paquete](#crear-un-paquete)
- [Instalar un paquete](#instalar-un-paquete)

## Estructura del proyecto
Esta sección est,a enfocada en desglosar la estructura del proyecto y la función de cada una de las partes.

- [backend](#backend)
- [frontend](#frontend)
- [installer](#installer)
- [release](#release)
- [testing](#testing)

### backend
> Contiene toda la lógica del negocio, y no se espera que el usuario normal al que va orientado el proyecto pueda acceder a él.
    
- database: Contiene la estructura de la base de datos.
- microservices: Contiene todos los microservicios que proporciona de funcionalidad al sistema, cada directorio hace referencia a un microservicio del mismo nombre.
    - CLI: Es el único subdirectorio que rompe la regla de estar orientado a un microservicio, teniendo como finalidad albergar una utilidad del mismo nombre para manejar todos los microservicos de manera conjunta.
        - Funcionalidad: Permite correr un conjunto de microservicios que se encuentre con la misma jerarquía previamente mencionada, a la vez que instalar las dependencias, con posibilidad de excluir microservicios en la ejecución o únicamente ejecutar algunos, como a su vez definir si la salida de los mismos sea verbosa o no. Para saber más de su funcionamiento se puede ejecutar con la bandera -h para desplegar la ayuda.

---

### frontend
> Contiene toda la vista del sistema.

- build: en este subdirectorio se almacena la versión compilada, de la vista.

---

### installer 
> Contiene todos los elementos necesarios para llevar a cabo la instalación del sistema.

- installer.sh: Es un script que permite la automatización de la instalación del sistema con los elementos que conforman el paquete de instalación.
    - Funcionamiento: Permite tanto la ejecución con un archivo de configuración para asignar puertos a los microservicios, como hacerlo de manera manual (para asignar un dominio o una ip al sistema debe de realizarse de manera manual en ambos casos, únicamente funciona esta asignación  si antes de la instalación estaba configurada en los archivos que conforman el paquete una IPv4). Para su ejecución es de forma absolutamente necesaria definir su modo de ejecución, en caso de no haberse seleccionado ninguno desplegará la lista de modos de ejecución.
- new_config.txt: En caso de haber seleccionado la instalación mediante un archivo de instalación mediante la ejecucion de installer.sh con la bandera -c, el instalador leera la configuración presente en este archivo, en el formato del nombre del microservicio seguido por un espacio y el puerto a asignar.
- old_config.txt: Es un archivo auxiliar para la instalación, que almacena la configuración que poseían los archivos del paquete de instalación antes de modificarlos. Es de suma importancia no eliminarlos durante la ejecución.
- config.txt: Es un archivo auxiliar para la instalación, una vez finalizada la instalación almacena la configuración presente.

---

### release
> Es un directorio que únicamente existe localmente al momento de generar un paquete de instalación, cuya finalidad es almacenar los paquetes generados.

- paquete: Cada paquete es nombrado por el sello de tiempo de cuando se generó. Se encuentra en el formato tar.xz con el fin de minimizar el espacio que ocupan. Para descomprimirlo hay que hacer uso del comando "tar -xf paquete".
- latest: Es un link simbólico que tiene la finalidad de ayudar a encontrar el último paquete generado.

---

### testing
> Contiene todas las suites de tests del proyecto, y el generador de releases.

- tests: El directorio está dedicado a almacenar las pruebas del sistema, para ejecutar las pruebas es necesario ejecutar "npm install" en el directorio padre, para descargar las dependencias.
- build_release.sh: Es un script que tiene la finalidad de agrupar todos los elementos necesarios del proyecto para la ejecución del sistema, y empaquetarlas en un tar.xz en caso de generar una release exitosa.
    - funcionamiento: Compila la vista del sistema, y la agrupa en la release si se compila sin ninguna advertencia. Por defecto prueba las apis con el servidor de desarrollo y las agrupas en caso de haber pasado su set de pruebas (actualmente se ejecutar el script con la bandera -f para desactivar las pruebas a los microservicios, ya que el servidor de desarrollo no estará en funcionamiento), y finalmente agrupa los demás elementos necesarios para el funcionamiento del sistema.

## Crear un paquete
Esta sección está enfocada a explicar el procedimiento necesario para generar un paquete que contenga todos los elementos del proyecto necesarios para su funcionamiento.

1. encontrarse en el directorio testing
2. ejecutar ./build_release.sh -f

## Instalar un paquete
En la sección anterior ya vimos cómo generar un paquete de instalación. Para instalar el sistema podemos usar un paquete generado por nosotros mismos o utilizar algunos de los presentes en el [repositorio](https://github.com/Daniel-dadu/PAE_web_platform/releases/).

1. Tener el paquete en el servidor en el cual se desee instalar.
2. Ejecutar el comando "tar -xf nombre_del_paquete.tar.xz"
2. Ejecutar el comando "cd nombre_del_paquete"
3. Ejecutar con permisos de superusuario el comando "./installer" con la bandera del modo deseado. La especificación de los modos de instalación fue definida anteriormente, a la vez que pude accederse al ejecutar el comando sin definir uno.

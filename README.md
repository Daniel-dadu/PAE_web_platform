# PAE web platform - Devsoft

## Estructura del proyecto
Esta seccion esta enfocada en desglosar la estructura del proyecto y la funcion que cada una de las partes posee.

- backend: Contiene toda la logica del negocio, y no se espera que el usuario normal al que va orientado el proyecto pueda acceder a el.
    - database: Contiene la estructura de la base de datos.
    - microservices: Contiene todos los microservicos que proporciona de funcionalidad al sistema, cada directorio hace referencia a un microservicio del mismo nombre.
        - CLI: Es el unico subdirectorio que rompe la regla de estar orientado a un microservicio, teniendo como finalidad albergar una utilidad del mismo nombre para manejar todos los microservicos de manera conjunta.
            - Funcionalidad: Permite correr un conjunto de microservicos que se encuentre con la misma jeraquia previamente mencionada, a la vez que instalar las depedencias, con posibilidad de excluir microservicos en la ejecucion o unicamente ejecutar algunos, como a su vez definir si la salida de los mismos sea verbosa o no. Para saber mas de su funcionamiento se puede ejecutar con la bandera -h para desplegar la ayuda.

---

- frontend: Contiene toda la vista del sistema.
    - build: en este subdirectorio se almacena la version compilada, de la vista.

---

- installer: Contiene todos los elementos necesarios para llevar a cabo la instalacion del sistema.
    - installer.sh: Es un script que permite la automatizacion de la instalacion del sistema con los elementos que conforman el paquete de instalacion.
        - Funcionamiento: Permite tanto la ejecucion con un archivo de configuracion para asignar puertos a los microservicios, como hacerlo de manera manual (para asignar un dominio o una ip al sistema debe de realizarse de manera manual en ambos casos, unicamente funciona esta asignacion  si antes de la instalacion estaba configurada en los archivos que conforman el paquete una IPv4). Para su ejecucion es de forma absolutamente necesaria definir su modo de ejecucion, en caso de no haberse selecionado ninguno desplegara la lista de modos de ejecucion.
    - new_config.txt: En caso de haber selecionado la instacion mediante un archivo de instalcion mediante la ejecucion de installer.sh con la bandera -c, el instalador leera la configuracion presente en este archivo, en el formato del no mbre Nombre del microservico seguido por un espacio y el puerto a asignar.
    - old_config.txt: Es un archivo auxiliar para la instlacion, que almacena la configuracion que poseian los arhicos del paquete de instalacion antes de modificarlos. Es de suma importancia no eliminarlos durante la ejecucion.
    - config.txt: Es un archivo auxiliar para la instalacion, una vez finalizada la instalacion almacena la configuracion presente.

---

- release: Es un directorio que unicamente existe loclamente al momento de generar un paquete de instalacion, cuya finalidad es alamacenar los paquetes generados.
    - paquete: Cada paquete es nombrado por el sello de tiempo de cuando se genero. Se encuentra en el formato tar.xz con el fin de minimizar el espacio que ocupan. Para descomprimirlo ha que hacer uso del comando "tar -xf paquete".
    - latest: Es un link simbolico que tiene la finalidad de ayudar a encontrar el ultimo paquete generado.

---

- testing: Contiene todas las suites de tests del proyecto, y el generador de releases.
    - tests: El directorio esta dedicado a almacenar las pruebas del sistema, para ejecutar las pruebas es necesario ejecutar "npm install" en el directorio padre, para descargar las depedencias.
    - build_release.sh: Es un script que tiene la finalidad de agrupar todos los elementos necesarios del projecto para la ejecucion del sistema, y empaquetarlas en un tar.zx en caso de generar una release exitosa.
        - funcionamiento: Compila la vista del sistema, y la agrupa en la release si se compila sin ninguna advertencia. Por defecto prueba las apis con el servidor de desarrollo y las agrupas en caso de haber pasado su set de pruebas (actualmente se ejecutar el script con la bandera -f para desactivar las pruebas a los microservicos, ya que el servidor de desarrollo no estara en funcionamiento), y finalmente agrupa los demas elementos necesarios para el funcionamiento del sistema.

## Crear un paquete
Esta seccion esta enfocada a explicar el procedimiento necesario para generar un paquete que contega todos los elementos del proyecto necesarios para su funcionamiento.

1. encontrarse en el directorio testing
2. ejecutar ./build_release.sh -f

## Instalar un paquete
En la seccion anterior ya vimos como generar un paquete de instalacion. Para instalar el sistema podemos usar un paquete generado por nosotros mismos o utilizar algunos de los presentes en el [repositorio](https://github.com/Daniel-dadu/PAE_web_platform/releases/).

1. Tener el paquete en el servidor en el cual se desee instalar.
2. Ejecutar el comando "tar -xf nombre_de_paquete.tar.xz"
2. Ejecutar el comando "cd nombre_del_paquete"
3. Ejecutar con permisos de superusuario el comando "./installer" con la bandera del modo deseado. El especificacion de los modos de instalacion fue definida anteriormente, a la vez que pude accederse al ejecutar el comando sin definir uno
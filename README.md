# Wyeworks project backend
This is the backend side of the project developed for WyeWorks. It's designed to connect students who need help with specific subjects to other students who can provide tutoring in those subjects.
## Tech stack
  * Ruby 3.3.4
  * Rails 7.2
  * Docker
## Installation
1. Asegúrate de tener Docker instalado en tu máquina..
> También se recomienda leer acerca del funcionamiento de Docker, al menos para tener un pantallazo de lo que se está haciendo.
2. Clonar el repositorio.
3. Asegurarse que los puertos 3000, 5050 y 5433 no estén siendo utilizados.
4. Ejecutar `docker-compose up --build -d` desde el directorio que contiene el clone de git.
> El -d es _opcional_, es para poder seguir utilizando la consola luego de levantar los contenedores.
5. Si es la primera vez que inicializas todo ejecuta el siguiente comando:
`docker exec -it rails-api /bin/sh`
> Esto te permitirá ingresar a la consola del contenedor que contiene la API, de esta manera puedes utilizar comandos dentro del contenedor.
6. Ejecuta `rails db:migrate` para crear el esquema de la base de datos (dentro del contendor).
7. En el caso de que hayan datos iniciales para cargar, también se debe de ingresar `rails db:seed`.

En este punto deberías de tener lo siguiente disponible:
- API: localhost:3000
- PGAdmin: localhost:5050
   * mail: un.mail@example.com
   * contraseña: admin
   - Se debe crear una conexion dándole nombre DB-API
   - En la pestaña conexión:
      * Dirección IP: 172.20.0.3 _(dirección de postgresql)_
      * Usuario: postgres
      * Contraseña: password
      * Puerto 5432 dentro del contenedor.
      * Puerto 5433 fuera de este (en tu máquina host).

> [!NOTE]
> El paso 4 y 5 **no** se debe hacer siempre que levantes los contenedores, en general se realiza cada vez que se altere el **esquema** de la base de datos mediante [migraciones](https://guides.rubyonrails.org/active_record_migrations.html). Por esto, la primera vez es obligatoria ya que la base de datos se encontrará vacía. Luego de esto, si estas trabajando y quieres crear una migración con rails, entonces estos pasos se deben de ejecutar otra vez para poder alterar el esquema de la base de datos que se encuentra dentro del contenedor.

## Trabajar con Docker
La idea de trabajar con Docker es que todos tengamos tanto las mismas versiones de las tecnologías, como un entorno de desarrollo aislado de incompatibilidades de diversos sistemas operativos. De esta manera tanto las pruebas como el desarrollo mismo se realiza de manera independiente al sistema operativo de cada desarrollador.

Algunas recomendaciones al desarrollar con Docker:
- Tener en cuenta que la información de la base de datos se persiste aunque el contenedor se baje, a su vez, cada base de datos de cada desarrollador puede contener datos **distintos** dependiendo de lo que cada uno haya hecho con el contenedor en sí, por esto, hay que tener en cuenta que el estado actual de nuestra base de datos puede hacer que el funcionamiento no sea exactamente el esperado.
- En general se puede desarrollar con los contenedores levantados, igualmente, es recomendable bajar los contenedores `docker-compose down` luego de terminar la sesión de desarrollo. Luego, para volver a levantarlos simplemente se hace `docker-compose up`.
- En el caso de querer actualizar las dependencias del proyecto (por ejemplo, querer utilizar una nueva [gema](https://medium.com/@morgannegagne/what-is-a-ruby-gem-1eec2684e68)) se debe volver a construir la imagen y probar que esto no traiga problemas al funcionamiento general del contenedor y la API en sí.
- En el caso de errores es recomendable utilizar el comando `docker-compose logs`.

## En caso de error al levantar el servidor con Docker
Algunos casos ocurre que devuelva error código 1, borre el archivo "server.pid" que se encuentra en tmp/pids.

## Docker commands
| Funcionalidad | Comando |
|---------------|---------|
| Información de los contenedores, imagenes, etc. |`docker inspect [nombre o id]`|
| Lista volumenes declarados.|`docker volume ls`|
| Lista los contenedores levantados.|`docker ps`|
| Lista las imagenes que tenes.|`docker images`|
| Remueve la/las imagen/es declaradas.|`docker rmi [nombre o id de imagen]`|
| Levantar los contenedores **sin crear la imagen otra vez**|`docker-compose up`|
| Para los contenedores.|`docker-compose down`|
| Elimina todas las imagenes huerfanas|`docker image prune -f`|
> Las imagenes huérfanas se te van a crear generalmente si levantas la misma imagen más de una vez, supongo que hay más formas de que esto pase, pero la que me pasó fué esta.

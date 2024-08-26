# README

## Inicializar el entorno de desarrollo:

1. Tener docker instalado en tu maquina.
2. Clonar el repositorio.
3. Ejecutar `docker-compose up --build -d` desde el directorio que contiene el clone de git.
> El -d es opcional, es para poder seguir utilizando la consola luego de levantar los contenedores.
4. Si es la primera vez inicializas todo deberías ingresar a la línea de comandos del contenedor en el que se encuentra la API ejecutando el siguiente comando:
`docker exec -it tutorias-api /bin/sh`
5. Ejecuta `rails db:migrate` para crear el esquema de la base de datos.

En este punto deberías de tener lo siguiente disponible:
- API: _localhost:3000_
- PGAdmin: _localhost:5050_
   * mail: un.mail@example.com
   * contraseña: admin
   - Se debe crear una conexion dandole nombre _DB-API_
   - En la pestaña conexión:
      * Dirección IP: 172.20.0.3
      * Usuario: _postgres_
      * Contraseña: _password_
      * Puerto 5432 dentro del contenedor.
      * Puerto 5433 fuera de este (en tu máquina host).

## Algunos comandos útiles para trabajar con Docker.
| Funcionalidad | Comando |
|---------------|---------|
| Información de los contenedores, imagenes, etc. |`docker inspect [nombre o id]`|
| Lista volumenes declarados.|`docker volume ls`|
| Lista los contenedores levantados.|`docker ps`|
| Lista las imagenes que tenes.|`docker images`|
| Remueve la/las imagen/es declaradas.|`docker rmi [nombre o id de imagen]`|
| Levantar los contenedores **sin crear la imagen otra vez**|`docker-compose up`|
| Para los contenedores.|`docker-compose down`|
| Elimina todas las imágenes huerfanas|`docker image prune -f`|
> Las imágenes huérfanas se te van a crear generalmente si levantas la misma imágen más de una vez, supongo que hay más formas de que esto pase, pero la que me pasó fué esta.

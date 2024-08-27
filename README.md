# Wyeworks project backend
This is the backend side of the project developed for WyeWorks. It's designed to connect students who need help with specific subjects to other students who can provide tutoring in those subjects.
## Tech stack
  * Ruby 3.3.4
  * Rails 7.2
  * Docker
## Installation

Things you may want to cover:

En este punto deberías de tener lo siguiente disponible:
1. API: localhost:3000
2. PGAdmin: localhost:5050
   * mail: un.mail@example.com
   * contraseña: admin
   - Se debe crear una conexion dandole nombre DB-API
   - En la pestaña conexión:
      * Dirección IP: 172.20.0.3 _(dirección de postgresql)_
      * Usuario: postgres
      * Contraseña: postgres
      * Puerto 5432 dentro del contenedor.
      * Puerto 5433 fuera de este (en tu máquina host).

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
| Elimina todas las imágenes huerfanas|`docker image prune -f`|
> Las imágenes huérfanas se te van a crear generalmente si levantas la misma imágen más de una vez, supongo que hay más formas de que esto pase, pero la que me pasó fué esta.

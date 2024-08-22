FROM ruby:3.0.2-alpine

# Instala las dependencias necesarias para la aplicación
RUN apk update && apk add --no-cache \
  postgresql-dev \
  build-base \
  nodejs \
  yarn \ 
  tzdata \
  git
  
WORKDIR /api
# Copia el contenido de la carpeta actual a la carpeta /api del contenedor
COPY . /api 
# Esto sirve para indicar las dependencias de la aplicación. 
# Si gamefile y gamefile.lock no cambian, no se volverá a instalar las dependencias.
COPY Gemfile Gemfile.lock ./ 
# Instala las dependencias de la aplicación
RUN bundle install
# Inicia el servidor de rails
CMD ["rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000

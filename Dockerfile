FROM ruby:3.0.2-alpine

LABEL Name=RailsImage Version=0.0.1

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN apk update && apk add --no-cache \
  postgresql-dev \
  build-base \
  nodejs \
  yarn \ 
  tzdata \
  git
  
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /api
COPY . /api 

# COPY Gemfile Gemfile.lock ./

RUN bundle install

CMD ["rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000

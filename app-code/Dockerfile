FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /clarkapp
WORKDIR /clarkapp
COPY ./Gemfile /clarkapp/Gemfile
COPY ./Gemfile.lock /clarkapp/Gemfile.lock
RUN  gem install bundler
RUN bundle install
COPY . /clarkapp
EXPOSE 3000
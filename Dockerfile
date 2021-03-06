# syntax = docker/dockerfile:1.0-experimental
FROM ruby:2.6.3-slim-stretch as builder
WORKDIR /app
RUN apt-get update && apt-get install -y wget gnupg2 curl
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' | tee /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
# yarn用
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && \
  apt-get install -y build-essential patch ruby-dev nodejs yarn libpq-dev postgresql-client
COPY Gemfile* ./
RUN gem uninstall bundler && gem install bundler -N -v=1.17.3 && bundle install -j4 --path vendor/bundle
COPY . ./

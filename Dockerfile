## Dockerfile

# Chọn image môi trường ruby
FROM ruby:2.5.1

# ENV
ENV NODE_VERSION 10

#Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/*

# Install packages
RUN apt-get update \
  && apt-get install -y \
  zlib1g-dev \
  build-essential \
  libssl-dev \
  libreadline-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt1-dev \
  libcurl4-openssl-dev \
  libffi-dev \
  git-core \
  vim \
  imagemagick

RUN apt-get update -qq && \
  apt-get install -y build-essential \
  default-libmysqlclient-dev \
  mysql-client \
  xvfb \
  redis-tools && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  lsof

#Clear lib
RUN apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

#Create workspace
ADD . /app/base
WORKDIR /app/base

#Clone gemfile
ENV BUNDLER_VERSION 2.0.2
RUN gem install bundler -v 2.0.2 && bundle install
RUN npm install -g yarn
RUN rails webpacker:install

CMD RAILS_ENV=development rake db:migrate && bundle exec puma -C config/puma.rb
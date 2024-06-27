# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.1.4
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

# Defina o ambiente de desenvolvimento
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Instalar pacotes necessários para construir gems e dependências do Ruby
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    pkg-config \
    libpq-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    ruby-dev \
    wget

# Instalar o código-fonte do Ruby para acessar os cabeçalhos necessários
RUN wget https://cache.ruby-lang.org/pub/ruby/3.1/ruby-3.1.4.tar.gz && \
    tar -xzf ruby-3.1.4.tar.gz && \
    cp -r ruby-3.1.4/include/* /usr/local/include/

# Instalar gems da aplicação
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.14 && \
    bundle config build.debase --with-ruby-include=/usr/local/include/ruby-3.1.0 && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copiar o código da aplicação
COPY . .

# Pré-compilar o código bootsnap para tempos de inicialização mais rápidos
RUN bundle exec bootsnap precompile app/ lib/

# Estágio final para imagem do app
FROM base

# Instalar pacotes necessários para o deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libsqlite3-0 \
    libvips \
    postgresql-client \
    libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copiar artefatos construídos: gems, aplicação
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000 1234
CMD ["./bin/rails", "server"]
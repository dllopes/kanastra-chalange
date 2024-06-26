# syntax = docker/dockerfile:1

# Certifique-se de que RUBY_VERSION corresponde à versão do Ruby no .ruby-version e Gemfile
ARG RUBY_VERSION=3.1.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# O app Rails vive aqui
WORKDIR /rails

# Defina o ambiente de produção
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Estágio de construção para reduzir o tamanho da imagem final
FROM base as build

# Instalar pacotes necessários para construir gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config libpq-dev

# Instalar gems da aplicação
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.14 && \
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
    apt-get install --no-install-recommends -y curl libsqlite3-0 libvips postgresql-client libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copiar artefatos construídos: gems, aplicação
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Executar e possuir apenas os arquivos de runtime como um usuário não root por segurança
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepara o banco de dados.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Iniciar o servidor por padrão, isso pode ser sobrescrito em runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
FROM ruby:3.1.3-alpine3.15

WORKDIR /app

COPY . .

USER root

ARG RAILS_MASTER_KEY
ARG RAILS_ENV

RUN apk add -U --no-cache \
      bash=5.1.16-r0 \
      libxslt=1.1.35-r0 \
      tzdata=2022f-r1 \
      shared-mime-info=2.1-r2 \
      imagemagick=7.1.0.16-r0 \
      mariadb-connector-c=3.1.13-r2 && \
    apk add -U --no-cache --virtual build-dependencies \
      curl \
      git=2.34.7-r0 \
      build-base=0.5-r3 \
      libxslt-dev=1.1.35-r0 \
      sqlite=3.36.0-r0 \
      sqlite-dev=3.36.0-r0 \
      mariadb-dev=10.6.12-r0 \
      nodejs=16.19.1-r0 \
      yarn=1.22.17-r0 && \
    gem install bundler:2.3.24 && \
    gem update --system && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle config set --local without "development test" && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    RAILS_ENV=production RAILS_MASTER_KEY=$RAILS_MASTER_KEY bundle exec rails assets:precompile && \
    rm -rf node_modules && \
    rm -rf /var/cache/apk/ && \
    chown nobody -R /app/db && \
    chown nobody -R /app/public && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log && \
    chmod +x .docker/app/entrypoint.sh

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

FROM harbor.k8s.temple.edu/library/ruby:3.3-alpine

WORKDIR /app

COPY . .

USER root

ARG RAILS_MASTER_KEY
ARG RAILS_ENV

RUN apk add -U --no-cache \
      bash=5.2.21-r0 \
      libxslt=1.1.39-r0 \
      tzdata=2024a-r0 \
      shared-mime-info=2.4-r0 \
      imagemagick=7.1.1.26-r0 \
      mariadb-connector-c=3.3.8-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      curl \
      git=2.43.0-r0 \
      build-base=0.5-r3 \
      libxslt-dev=1.1.39-r0 \
      sqlite=3.44.2-r0 \
      sqlite-dev=3.44.2-r0 \
      mariadb-dev=10.11.6-r0 \
      nodejs=20.11.1-r0 \
      yarn=1.22.19-r0 && \
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

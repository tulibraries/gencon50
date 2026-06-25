FROM harbor.k8s.temple.edu/library/ruby:3.4-alpine

WORKDIR /app

COPY . .

USER root

ARG RAILS_MASTER_KEY
ARG RAILS_ENV

RUN apk add -U --no-cache \
      bash=5.3.9-r1 \
      libxslt=1.1.43-r3 \
      tzdata=2026b-r0 \
      shared-mime-info=2.4-r7 \
      imagemagick=7.1.2.24-r0 \
      mariadb-connector-c=3.4.6-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      curl \
      git=2.54.0-r0 \
      build-base=0.5-r4 \
      libxslt-dev=1.1.43-r3 \
      sqlite=3.53.2-r0 \
      sqlite-dev=3.53.2-r0 \
      mariadb-dev=11.8.8-r0 \
      yaml-dev=0.2.5-r2 && \
    gem install bundler:2.3.24 && \
    gem update --system && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle config set --local without "development test" && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    RAILS_ENV=production RAILS_MASTER_KEY=$RAILS_MASTER_KEY bundle exec rails assets:precompile && \
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

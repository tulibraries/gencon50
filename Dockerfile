FROM ruby:2.6.5
RUN \
      wget -qO- https://deb.nodesource.com/setup_9.x | bash - && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update -qq && \
      apt-get install -y --force-yes --no-install-recommends \
      nodejs build-essential libpq-dev sqlite3 openjdk-11-jre openjdk-11-jdk

RUN mkdir /gencon50
WORKDIR /gencon50
RUN git clone https://github.com/tulibraries/gencon50.git .
RUN gem install -f bundler --version "2.1.4"
RUN bundle install
RUN bundle exec rake db:setup
RUN bundle exec rake db:migrate

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

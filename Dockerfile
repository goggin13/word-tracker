# Base our image on an official, minimal image of our preferred Ruby
FROM ruby:2.3.8-slim

# Install essential Linux packages
RUN apt-get update -qq
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN apt-get install -y libsqlite3-dev

# https://stackoverflow.com/questions/51033689/how-to-fix-error-on-postgres-install-ubuntu
RUN mkdir -p /usr/share/man/man1
RUN mkdir -p /usr/share/man/man7
RUN apt-get install -y postgresql-client

RUN apt-get install -y curl

# Define where our application will live inside the image
ENV RAILS_ROOT /var/www/word-tracker
ENV RAILS_ENV development

# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
COPY Gemfile Gemfile

COPY Gemfile.lock Gemfile.lock

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler -v 1.15.0

# Finish establishing our Ruby enviornment
RUN bundle install

# Copy the Rails application into place
COPY . .

CMD bundle exec rails server -p 5000 --pid $RAILS_ROOT/tmp/pids/$(hostname).pid -b 0.0.0.0 --env $RAILS_ENV

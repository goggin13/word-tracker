# Base image (https://registry.hub.docker.com/_/ubuntu/)
FROM ubuntu

# Install required packages
RUN apt-get update
RUN apt-get install -y libpq-dev ruby2.0 ruby2.0-dev bundler curl vim

# Create directory from where the code will run
RUN mkdir -p /word-tracker/app
WORKDIR /word-tracker/app

# Make unicorn reachable to other containers
# EXPOSE 3000

# Container should behave like a standalone executable
# ENTRYPOINT ["bundle exec rails server"]

# Install the necessary gems
ADD Gemfile /word-tracker/app/Gemfile
ADD Gemfile.lock /word-tracker/app/Gemfile.lock
RUN bundle install

# Copy application code to container
ADD . /word-tracker/app/

CMD bundle exec rails server -p 4000

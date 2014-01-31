gem install bundler
bundle
bundle exec rake db:create
bundle exec rake db:migrate
rvmsudo foreman export upstart /etc/init -a word-tracker -u ubuntu

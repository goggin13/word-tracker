docker exec \
  word-tracker-web \
  bundle exec rake db:create

docker exec \
  word-tracker-web \
  bundle exec rake db:migrate

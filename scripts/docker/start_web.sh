sudo docker run -d --name word_tracker_web_1 \
  --link word_tracker_db:db \
  --env "RAILS_ENV=production" \
  --publish 4000:4000 \
  --volume /home/goggin/word-tracker:/word-tracker/app \
  word_tracker_web:v1

sudo docker run -d --name word_tracker_web_2 \
  --link word_tracker_db:db \
  --env "RAILS_ENV=production" \
  --publish 4001:4000 \
  word_tracker_web:v1

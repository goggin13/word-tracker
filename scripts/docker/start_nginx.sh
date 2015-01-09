sudo docker run -d --name word_tracker_nginx \
  --link word_tracker_web_1:word_tracker_web_1 \
  --link word_tracker_web_2:word_tracker_web_2 \
  --publish 80:80 \
  --volume /home/goggin/word-tracker/public:/assets/word-tracker/public \
  word_tracker_nginx:v1

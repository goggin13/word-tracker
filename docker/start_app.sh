source docker/common.sh

docker run \
  -it \
  --env-file ../infrastructure/modules/word-tracker/files/word_tracker.env \
  -p 5000:5000 \
  --name word-tracker-web \
  -v $LOCAL_VOLUME_PATH:/var/www/word-tracker \
  --rm \
  goggin13/word-tracker

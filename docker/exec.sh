source docker/common.sh

if docker ps | grep -o word-tracker-web ; then
  docker exec -it word-tracker-web bash
else
  docker run \
    -it \
    --env RAILS_ENV=test \
    --env-file ../infrastructure/modules/word-tracker/files/word_tracker.env \
    -p 5000:5000 \
    --name word-tracker-web \
    -v $LOCAL_VOLUME_PATH:/var/www/word-tracker \
    --rm \
    goggin13/word-tracker \
    bash
fi

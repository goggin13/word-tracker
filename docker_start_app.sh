docker run \
  -it \
  --env-file ../infrastructure/modules/word-tracker/files/word_tracker.env \
  -p 4000:4000 \
  --name word-tracker-web \
  --rm \
  98e4e309c578

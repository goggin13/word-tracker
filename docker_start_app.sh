docker run \
  -it \
  --env-file ../infrastructure/modules/word-tracker/files/word_tracker.env \
  -p 4000:4000 \
  --name word-tracker-web \
  -v /Users/mgoggin/Documents/projects/word-tracker:/var/www/word-tracker \
  --rm \
  goggin13/word-tracker

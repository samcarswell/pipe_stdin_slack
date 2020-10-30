#!/bin/bash

SCRIPT_NAME=$1

echo $SCRIPT_NAME

source ~/.slack_key

echo $SLACK_WEBHOOK_URL

# check for a pipe
if [ -p /dev/stdin ]; then
  temp_file=$(mktemp /tmp/cron_slack.XXXXXXXXX)

  echo $temp_file

  echo "\`${SCRIPT_NAME}\` CRON has run on Husky:" > $temp_file
  echo '```' >> $temp_file
  while IFS= read line; do
    echo ${line} >> $temp_file
  done
  echo '```' >> $temp_file


  data='{"text":"'
  data+=$(cat $temp_file)
  data+='"}'

  curl -X POST -H 'Content-type: application/json' --data "$data" "https://hooks.slack.com/services/${SLACK_WEBHOOK_URL}"

  rm $temp_file
fi


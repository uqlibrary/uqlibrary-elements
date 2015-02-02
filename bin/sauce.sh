#!/bin/bash
branch=$(git rev-parse --abbrev-ref HEAD)
case "$branch" in
"master")
  wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
  --sauce "OSX 10.9/safari@7.0"
  ;;
"uat")
  wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
  --sauce "OSX 10.9/safari@7.0" \
  --sauce "Windows 8.1/chrome@39.0"
  ;;
"staging")
  wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
  --sauce "OSX 10.9/safari@7.0" \
  --sauce "Windows 8.1/chrome@39.0" \
  --sauce "Windows 8.1/firefox@35.0" \
  --sauce "Windows 8.1/internet explorer@11.0"
  ;;
"production")
  wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
  --sauce "OSX 10.9/safari@7.0" \
  --sauce "Windows 8.1/chrome@39.0" \
  --sauce "Windows 8.1/firefox@35.0" \
  --sauce "Windows 8.1/internet explorer@11.0"
  ;;
esac
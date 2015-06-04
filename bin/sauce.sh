#!/bin/bash
if [ -z $CI_BRANCH ]; then
  branch=$(git rev-parse --abbrev-ref HEAD)
else
  branch=$CI_BRANCH
fi
case "$branch" in
"master")
  wct --plugin local --local "chrome"
  ;;
"uat")
  wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
  --sauce "OSX 10.9/safari@7.0" \
  --sauce "Windows 8.1/chrome@43.0"
  ;;
"staging")
  wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
  --sauce "OSX 10.9/safari@7.0" \
  --sauce "Windows 8.1/chrome@43.0" \
  --sauce "Windows 8.1/firefox@37.0" \
  --sauce "Windows 8.1/internet explorer@11.0"
  ;;
"production")
  wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
  --sauce "OSX 10.9/safari@7.0" \
  --sauce "Windows 8.1/chrome@43.0" \
  --sauce "Windows 8.1/firefox@37.0" \
  --sauce "Windows 8.1/internet explorer@11.0"
  ;;
*)
  echo "couldn't detect branch"
  wct --plugin local --local "chrome" --local "firefox"
  ;;
esac

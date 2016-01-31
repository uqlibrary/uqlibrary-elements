#!/bin/bash
if [ -z $CI_BRANCH ]; then
  branch=$(git rev-parse --abbrev-ref HEAD)
else
  branch=$CI_BRANCH
fi
case "$branch" in
"master")
  wct --plugin local --local "chrome"
  wct --plugin local --local "firefox"
  ;;
"uat")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "OSX 10.10/safari@8.0"
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/chrome@47.0"
  ;;
"staging")
  case "$PIPE_NUM" in
  "1")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "OSX 10.10/safari@8.0"
    ;;
  "2")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/chrome@47.0"
    ;;
  "3")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/firefox@37.0"
    ;;
  "4")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/internet explorer@11.0"
    ;;
  *)
  echo "couldn't detect pipeline: just testing on IE"
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/internet explorer@11.0"
    ;;
  esac
  ;;
"production")
  case "$PIPE_NUM" in
  "1")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "OSX 10.10/safari@8.0"
    ;;
  "2")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/chrome@47.0"
    ;;
  "3")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/firefox@37.0"
    ;;
  "4")
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/internet explorer@11.0"
    ;;
  *)
  echo "couldn't detect pipeline: just testing on IE"
    wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
    --sauce "Windows 8.1/internet explorer@11.0"
    ;;
  esac
  ;;
*)
  echo "couldn't detect branch"
  wct --plugin local --local "chrome" --local "firefox"
  ;;
esac

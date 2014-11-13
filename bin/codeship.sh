#!/bin/bash

set -xe

src=$(echo ~/src/github.com/uqlibrary/uqlibrary-elements)

cd ${src}
bower install
cd ..

# Get a list of uplibrary-* components (excluding this one)
components=$(ls -d */ | grep uqlibrary | grep -v elements)

# Run the tests for each component and vulcanize the index page
for component in ${components[@]}; do
  cd ${component}
  #if [ -d "test" ]; then
  #  wct
  #fi
  if [ -f "index.html" ]; then
    vulcanize -o index.html index.html
  fi
  cd ..
  cp -R ${component} "${component/uqlibrary-/}"
done

# Use env vars to set AWS config
set +x
awsconfig="${src}/aws.json"
sed -e s/"<AWSAccessKeyId>"/"${AWSSecretKey}"/g -i ${awsconfig} >/dev/null
sed -e s/"<AWSSecretKey>"/"${AWSSecretKey}"/g -i ${awsconfig} >/dev/null
sed -e s/"<S3Bucket>"/"${S3Bucket}"/g -i ${awsconfig} >/dev/null
sed -e s/"<CFDistribution>"/"${CFDistribution}"/g -i ${awsconfig} >/dev/null
sed -e s/"<AWSRegion>"/"${AWSRegion}"/g -i ${awsconfig} >/dev/null
set -x

# Gzip the files prior to uploading
find . -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;

cd ${src}
grunt deploy

rm -f ${awsconfig}

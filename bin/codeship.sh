#!/bin/bash

set -xe

src=$(echo ~/src/github.com/uqlibrary/uqlibrary-elements)

cd ${src}
bower install
cd ..

# Get a list of uplibrary-* components (excluding this one), run the tests and vulcanize
components=$(ls -d */ | grep uqlibrary | grep -v elements)
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

# Gzip component files
set +x
components=$(ls -d */ | grep -v uqlibrary-elements)
for component in ${components[@]}; do
  cd ${component}
  find . -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
  cd ..
done

# Use env vars to set AWS config
awsconfig="${src}/aws.json"
sed -i -e 's#<AWSAccessKeyId>#${AWSSecretKey}#g' ${awsconfig}
sed -i -e 's#<AWSSecretKey>#${AWSSecretKey}#g' ${awsconfig}
sed -i -e 's#<S3Bucket>#${S3Bucket}#g' ${awsconfig}
sed -i -e 's#<CFDistribution>#${CFDistribution}#g' ${awsconfig}
sed -i -e 's#<AWSRegion>#${AWSRegion}#g' ${awsconfig}
set -x

cd ${src}
ls -la
which grunt
grunt deploy

rm -f ${awsconfig}

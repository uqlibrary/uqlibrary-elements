#!/bin/bash

set -xe

src=$(git rev-parse --show-toplevel)
base=$(basename ${src})
#tag=$(git describe --exact-match --tags HEAD)

bower install

# Gzip component files
find . -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
find ../uqlibrary-elements/resources -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
find ../uqlibrary-elements -type d -regex "../uqlibrary-elements/[0-9].*" ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
cd ..
cp -R ${base} "${base/uqlibrary-/}"

# Use env vars to set AWS config
set +x
cd uqlibrary-elements
awsconfig="aws.json"
sed -i -e "s#<AWSAccessKeyId>#${AWSAccessKeyId}#g" ${awsconfig}
sed -i -e "s#<AWSSecretKey>#${AWSSecretKey}#g" ${awsconfig}
sed -i -e "s#<S3Bucket>#${S3Bucket}#g" ${awsconfig}
sed -i -e "s#<CFDistribution>#${CFDistribution}#g" ${awsconfig}
sed -i -e "s#<AWSRegion>#${AWSRegion}#g" ${awsconfig}

grunt deploy
set -x

rm -f ${awsconfig}

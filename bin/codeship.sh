#!/bin/bash

set -xe

if [ ${CI_BRANCH} = "staging" ]; then
  grunt predeploy
fi

src=$(git rev-parse --show-toplevel)
base=$(basename ${src})
#tag=$(git describe --exact-match --tags HEAD)

# Gzip component files
cd ${src}
find . -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
find ../uqlibrary-elements/resources -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
find ../uqlibrary-elements -type f -regex "../uqlibrary-elements/[0-9].*" ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
cd ..
cp -R ${base} "${base/uqlibrary-/}"

# Use env vars to set AWS config
set +x
cd uqlibrary-elements
awsconfig="aws.json"

# use codeship branch environment variable to push to branch name dir unless it's 'production' branch (or master for now)
if [ ${CI_BRANCH} != "production" ]; then
  export BucketSubDir=/${CI_BRANCH}
else
  export BucketSubDir=''
fi

sed -i -e "s#<AWSAccessKeyId>#${AWSAccessKeyId}#g" ${awsconfig}
sed -i -e "s#<AWSSecretKey>#${AWSSecretKey}#g" ${awsconfig}
sed -i -e "s#<S3Bucket>#${S3Bucket}${BucketSubDir}#g" ${awsconfig}
sed -i -e "s#<CFDistribution>#${CFDistribution}#g" ${awsconfig}
sed -i -e "s#<AWSRegion>#${AWSRegion}#g" ${awsconfig}

echo "${CI_BRANCH}"



grunt deploy
set -x

rm -f ${awsconfig}

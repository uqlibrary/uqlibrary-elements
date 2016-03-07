#!/bin/bash

set -xe

echo "${CI_BRANCH}"
src=$(git rev-parse --show-toplevel)
base=$(basename ${src})

pwd
cd ../uqlibrary-elements
pwd

#run file revision, css min tasks
if [ ${CI_BRANCH} = "staging" ] || [ ${CI_BRANCH} = "production" ]; then
  grunt predeploy
fi

#tag=$(git describe --exact-match --tags HEAD)

# Gzip component files
cd ${src}
find . -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
find ../uqlibrary-elements/resources -type f ! -name '*.gz' -exec gzip "{}" \; -exec mv -f "{}.gz" "{}" \;
find ../uqlibrary-elements -type f -regex "../uqlibrary-elements/[0-9].*" ! -name '*.gz' -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;
cd ..
cp -R ${base} "${base/uqlibrary-/}"

# set up directory aliases
if [ ${base} = "uqlibrary-chat" ]; then
  ln -s ${base} contact
fi

# Use env vars to set AWS config
set +x
cd uqlibrary-elements
awsconfig="aws.json"

# use codeship branch environment variable to push to branch name dir unless it's 'production' branch (or master for now)
if [ ${CI_BRANCH} != "production" ]; then
  export S3BucketSubDir=/${CI_BRANCH}
else
  export S3BucketSubDir=''
fi

sed -i -e "s#<AWSAccessKeyId>#${AWSAccessKeyId}#g" ${awsconfig}
sed -i -e "s#<AWSSecretKey>#${AWSSecretKey}#g" ${awsconfig}
sed -i -e "s#<S3Bucket>#${S3Bucket}#g" ${awsconfig}
sed -i -e "s#<S3BucketSubDir>#${S3BucketSubDirVersion}${S3BucketSubDir}#g" ${awsconfig}
sed -i -e "s#<CFDistribution>#${CFDistribution}#g" ${awsconfig}
sed -i -e "s#<AWSRegion>#${AWSRegion}#g" ${awsconfig}

grunt deploy
set -x

rm -f ${awsconfig}

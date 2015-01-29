#!/bin/bash

set -xe

# use codeship branch environment variable to push to branch name dir unless it's 'production' branch (or master for now)
if [ ${CI_BRANCH} != "production" ] && [ ${CI_BRANCH} != "master" ]; then
  export BucketSubDir=/${CI_BRANCH}
else
  export BucketSubDir=''
fi
echo ${BucketSubDir}
export S3Bucket=uql-app-v1/v1
awsconfig="aws.json"
sed -i -e "s#<AWSAccessKeyId>#${AWSAccessKeyId}#g" ${awsconfig}
sed -i -e "s#<AWSSecretKey>#${AWSSecretKey}#g" ${awsconfig}
sed -i -e "s#<S3Bucket>#${S3Bucket}${BucketSubDir}#g" ${awsconfig}
sed -i -e "s#<CFDistribution>#${CFDistribution}#g" ${awsconfig}
sed -i -e "s#<AWSRegion>#${AWSRegion}#g" ${awsconfig}
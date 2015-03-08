#!/bin/bash

set -xe

#src=$(git rev-parse --show-toplevel)
#base=$(basename ${src})
polymer=$(cat bower.json | grep "Polymer/polymer#" | cut -d'#' -f2 | cut -d'"' -f1)
#tag=$(git describe --exact-match --tags HEAD)
echo ${polymer}
# Gzip component files
cd ${polymer}

# Get a list of uplibrary-* components (excluding this one).
components=$(ls -d */ | grep uqlibrary | grep -v elements)
echo $components
COUNTER=0
# Run the tests for each component
for component in ${components[@]}; do
  # if this is inside a codeship test pipeline, only run if its for this pipe number
  if [[ -z $PIPE_NUM && -z $PIPE_TOTAL ]]; then
    cd $component
    if [ -d "test" ]; then
      echo $(pwd)
      ../../bin/local_tests.sh
    fi
    cd ..
  else
    let COUNTER=COUNTER+1
    echo "PIPE NUM = " $PIPE_NUM "PIPE_TOTAL = " $PIPE_TOTAL
    if [[ $(( $COUNTER % $PIPE_TOTAL )) == $PIPE_NUM ]]; then
      cd $component
      if [ -d "test" ]; then
        echo $(pwd)
        ../../bin/local_tests.sh
      fi
      cd ..
    fi
  fi
done

cd ..
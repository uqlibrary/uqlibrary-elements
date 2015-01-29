#!/bin/bash

set -xe

#src=$(git rev-parse --show-toplevel)
#base=$(basename ${src})
polymer=$(cat bower.json | grep "Polymer/polymer#" | cut -d'#' -f2 | cut -d'"' -f1)
#tag=$(git describe --exact-match --tags HEAD)

# Gzip component files
cd ${polymer}

# Get a list of uplibrary-* components (excluding this one)
components=$(ls -d */ | grep uqlibrary | grep -v elements)

# Run the tests for each component
for component in ${components[@]}; do
  cd $component
  if [ -d "test" ]; then
    wct
  fi
  cd ..
done

cd ..
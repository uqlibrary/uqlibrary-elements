#!/bin/bash

set -xe

cd ~/src/github.com/uqlibrary/uqlibrary-elements/
bower install
cd ..

# Get a list of uplibrary-* components (excluding this one)
components=$(ls -d */ | grep uqlibrary | grep -v elements)

# Run the tests for each component
for component in ${components[@]}; do
  cd $component
  #wct
  cd ..
  cp -R $component "${component/uqlibrary-/}"
done


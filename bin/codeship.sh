#!/bin/bash

set -xe

basedir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../ && pwd )
cd $basedir
cd ./../src/github.com/uqlibrary/uqlibrary-elements/
bower install
cd ..

# Get a list of uplibrary-* components (excluding this one)
components=$(ls -d */ | grep uqlibrary | grep -v elements)

# Run the tests for each component
for component in ${components[@]}; do
  cd $component
  #wct
  cd ..
done

ls -la

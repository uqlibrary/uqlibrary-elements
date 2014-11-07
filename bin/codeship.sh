#!/bin/bash

bower install

# Get a list of uplibrary-* components (excluding this one)
cd ../..
components=$(ls -d */ | grep uqlibrary | grep -v elements)

# Run the tests for each component
for component in ${components[@]}; do
  cd $component
  wct
  cd ..
done


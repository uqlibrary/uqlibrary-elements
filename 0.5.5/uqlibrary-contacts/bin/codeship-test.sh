#!/bin/bash

echo "Testing branch: ${CI_BRANCH}"

./bin/codeship-setup.sh
# Run old tests
cd ../uqlibrary-elements
./bin/elements_local_tests.sh
cd ../uqlibrary-contacts
../uqlibrary-elements/bin/sauce.sh
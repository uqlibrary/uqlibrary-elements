#!/bin/bash

# Run old tests
npm install -g wct-sauce web-component-tester
export NPM_ROOT=$(npm root -g)
cp -r $NPM_ROOT/wct-sauce $NPM_ROOT/web-component-tester/node_modules
git clone -b ${CI_BRANCH} --single-branch https://github.com/uqlibrary/uqlibrary-elements ../uqlibrary-elements
chmod 755 ../uqlibrary-elements/bin/*.sh
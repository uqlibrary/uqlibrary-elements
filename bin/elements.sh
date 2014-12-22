#!/bin/bash

base=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
polymer=$(cat bower.json | grep "Polymer/polymer#" | cut -d'#' -f2 | cut -d'"' -f1)

echo "{
  \"directory\": \"${polymer}\"
}
" > .bowerrc
rm -Rf ${polymer}

bower install
mkdir ${polymer}/lib
cp index.html ${polymer}/lib/index.html
cd ${polymer}/lib/

#vulcanize -o vulcanized.html index.html
vulcanize -csp -strip -o vulcanized.html index.html

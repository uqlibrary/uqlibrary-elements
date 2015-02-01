#!/bin/bash

base=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
polymer=$(cat bower.json | grep "Polymer/polymer#" | cut -d'#' -f2 | cut -d'"' -f1)
branch=$(git rev-parse --abbrev-ref HEAD)

echo "{
  \"directory\": \"${polymer}\"
}
" > .bowerrc
rm -Rf ${polymer}

#put in the current branch name into bower.json
sed -i -e "s#<branch>#${branch}#g" bower.json
bower install
#put in the template branch name back into bower.json so it doesnt accidentally get committed back
sed -i -e "s#${branch}#<branch>#g" bower.json
mkdir ${polymer}/lib
cp index.html ${polymer}/lib/index.html
cd ${polymer}/lib/

#vulcanize --config ../../vulcanize.conf -o vulcanized.html index.html
vulcanize --config ../../vulcanize.conf -csp -strip -o vulcanized.html index.html

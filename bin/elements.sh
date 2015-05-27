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
#put in the template branch name back into bower.json so it does not accidentally get committed back
sed -i -e "s#${branch}#<branch>#g" bower.json
rm -f bower.json-e
mkdir ${polymer}/lib
cp index*.html ${polymer}/lib/
rm ${polymer}/lib/index-template.html # Remove this file as it shouldn't be vulcanized
cd ${polymer}/lib/

for filename in index*.html; do
  vulcanized_name="${filename/index/vulcanized}"
  echo "Vulcanizing ${filename}"
  vulcanize --config ../../vulcanize.conf --inline -csp -strip -o ${vulcanized_name} ${filename}
  #vulcanize --config ../../vulcanize.conf -o ${vulcanized_name} ${filename}
  #vulcanize --config ../../vulcanize.conf -csp -strip -o ${vulcanized_name} ${filename}
done

# updating path to css files after vulcanization
grunt replace
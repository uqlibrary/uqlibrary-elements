uqlibrary-elements
================

An aggregate of components used in apps, combining the components into a vulcanized file, and contains the 
build script for deploying applications.

## Getting Started

### Adding a component

To add a component, edit the bower.json file, and add the component as a dependency.

Edit the index.html file in the root of the repo and include the component so it will be vulcanized.

Next run the elements.sh script in the bin directory locally, which will generate a vulcanized file that 
can be included in your app:

    $ cd /path/to/repo
    $ bin/elements.sh

The script uses the Polymer version in bower.json to determine the directory components are installed into.

Once the script completes, commit this repo with the updated components.

### Deploying

Each app is deployed using codeship.io. The script bin/codeship.sh is run on codeship.io to gzip the 
application, and to upload the application to S3.

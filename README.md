uqlibrary-elements
================

An aggregate of components used in apps, combining the components into a vulcanized file, and contains the
build script for deploying applications.

[ ![Codeship Status for uqlibrary/uqlibrary-elements](https://codeship.com/projects/391b0aa0-882d-0132-a5ab-42354043e837/status?branch=master)](https://codeship.com/projects/59351)

## Getting Started

### Install requirements

Follow the quick start guide for UQLApp described here to ensure you have the required command line tools: https://github.com/uqlibrary/uqlapp/blob/master/docs/quick_start/readme.md

Continue the quick start guide onto the frontend development guide to ensure you have the required package management tools:
https://github.com/uqlibrary/uqlapp/blob/master/docs/quick_start/frontend.md

### Frontend development

If this is your first time using Polymer, be sure to start with these guides:

https://www.polymer-project.org/docs/start/tutorial/intro.html

https://www.polymer-project.org/docs/start/reusableelements.html

Before pulling anything from this repo, you'll first want to create a folder in your main directory that will contain all the required component folders. You probably don't want to use your top-level development folder as it will quickly fill up with all sorts of web components. Instead, use something like:

    $ /path/to/development/uqlibrary
    $ cd /path/to/development/uqlibrary

Once in your chosen directory, you should pull the individual components that you want to work with (e.g. uqlibrary-booking) into this directory. Then do the following:

    $ cd /path/to/development/uqlibrary/uqlibrary-{component-name}
    $ bower install

Be sure to also pull any related components that are used by the component you want to work on. For example, uqlibrary-booking uses uqlibrary-timeline. If you experience any errors at this stage, check that the dependencies in the bower.json file are correct.

Finally, you should install vulcanizer so that you can add your changes to this aggregate uqlibrary-elements repository:

    $ npm install -g vulcanize

and polymer-tools

https://github.com/Polymer/tools

so you can update individual web component demo pages, thus helping others to understand and use them.

    $ mkdir temp && cd temp && ../../tools/bin/gp.sh uqlibrary uqlibrary-ELEMENT_NAME && cd .. && rm -rf temp

this will create a new gh-pages branch on the repo and let you link to its component page, and its demo page.

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

### Running with mock data

To use mock data set cookie value UQLMockData to enabled (cookie values are strings).

```sh
      //add a cookie to indicate usage of mock data
      document.cookie="UQLMockData=enabled";
```

### Styling Guidelines

See the styling example here: https://uqlibrary.github.io/uqlibrary-elements/components/uqlibrary-elements/styles.html

### Styling Implementation Guidelines

Do's

Don'ts
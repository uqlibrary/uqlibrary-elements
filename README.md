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

### Branches

Master is the development branch. All small development should be done here, but large changes should be done in their own feature branches.

UAT is for User Acceptance testing for non-developers.

Staging is for final browser testing and necessary manual (mainly CSS visual rendering) testing before going into Production
 
Production gets deployed to the live production site.

### Deploying

Each app is deployed using codeship.io. The script bin/codeship.sh is run on codeship.io to gzip the
application, and to upload the application to S3.

Codeship builds are triggered automatically on every push to GitHub.

Each branch is monitored and deploys to a separate subdirectory with that branch name, eg /v1/staging/home, /v1/uat/home. 
Except for production which goes directly into the /v1/ directory e.g. /v1/home, /v1/borrowing.

Automated tests are triggered during deployment and are run in staggered degrees of browser compatibility checking depending on branch:
  * Master: Runs only latest chrome, directly on CodeShips local deployment VM
  * UAT: Runs OSX Safari 7.0 and Windows 8.1 Chrome 39 via SauceLabs
  * Staging: Same as UAT, but adds Windows 8.1 Firefox 35 and Internet Explorer 11
  * Production: Same as Staging

This is covered in the bin/sauce.sh script.
  
Note: CSS Rendering issues are not currently tested (only javascript) need to be performed manually. 
At least until we can look at adding PhantomCSS (with it's SauceLabs experimental integration).

Each application (e.g. Courses) runs the uqlibrary-elements tests and it's own tests.
In addition there is a uqlibrary-elements codeship build which only runs the uqlibrary-elements tests, but performs no deployment.
The uqlibrary-elements tests in sub-application build triggers will be changed to only run the tests in chrome on the Codeship VM, 
no matter what branch, with full browser test coverage staying on the uqlibrary-elements codeship build itself. 
This will be done to speed up deployment while keeping some level of safety net.

### Testing

Testing should be performed locally (in your development environment) and all tests should be passing prior to pushing to Master.

Tests can be run locally by running:

```
wct --plugin local --local "chrome" --local "firefox" --local "safari"
```

Or by setting up SauceLabs environment variables (SAUCE_USERNAME and SAUCE_ACCESS_KEY) and running via that service:

```
wct --plugin sauce --sauce-username=${SAUCE_USERNAME} --sauce-access-key=${SAUCE_ACCESS_KEY} \
     --sauce "OSX 10.9/safari@7.0" \
     --sauce "Windows 8.1/chrome@39.0" \
     --sauce "Windows 8.1/firefox@35.0" \
     --sauce "Windows 8.1/internet explorer@11.0"
```

Each new sub-application should have at least one functional and at least one unit test.
The unit test should use in-built mock data, while the functional test should pull the mock data from the uqlibrary-api web component.

### Running with mock data

To use mock data set cookie value UQLMockData to enabled (cookie values are strings).

```sh
      //add a cookie to indicate usage of mock data
      document.cookie="UQLMockData=enabled";
```

### Styling Guidelines

See the styling example here: [styles.html](https://uqlibrary.github.io/uqlibrary-elements/components/uqlibrary-elements/styles.html)

### Styling Implementation Guidelines

1. Seperate elements use elements.css from uqlibrary-elements/resources/theme (e.g. uqlibrary-persistent-footer)
2. Element.css is excluded from vulcanization in vulcanize.conf
3. Grunt-text-replace runs to update path in vulcanized.html to point to relative element.css
4. Grunt predeploy task runs following commands (for staging and production environments):
  * cssmin - to minify element.css and application.css
  * file-rev - to include revision number in file names for *.js *.css and vulcanized.html
  * usemin - updates references to file-rev files

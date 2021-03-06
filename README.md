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

Install bower:

    $ npm install -g bower

Install grunt:

    $ npm install -g grunt-cli

### Frontend development

If this is your first time using Polymer, be sure to start with these guides:

https://www.polymer-project.org/docs/start/tutorial/intro.html

https://www.polymer-project.org/docs/start/reusableelements.html

* UQLibrary elements

Custom elements are reusable components that can be used in different web apps, eg uqlibrary-menu, uqlibrary-api). 
To start custom elements development:

    # to create a new element
    $ git clone https://github.com/uqlibrary/uqlibrary-element-template.git
    
    # to modify existing element
    $ git clone https://github.com/uqlibrary/uqlibrary-{element-name}.git
    
    $ bower install
    $ git clone https://github.com/uqlibrary/uqlibrary-elements.git
    
Update all references to 'uqlibrary-element-template' to your element name, eg 'uqlibrary-special-button', run demo/index.html to test your custom element.

Any element specific styles should be added to uqlibrary-{element-name}.scss, if a style can be reused in other elements, it should be added to common styles in uqlibrary-elements.

These custom elements are assembled in uqlibrary-elements by vulcanization (more in 'Adding a component' section).

Create custom element demo pages to help others understand how custom element looks like:

    $ git clone https://github.com/Polymer/tools.git
    $ mkdir temp && cd temp && ../../tools/bin/gp.sh uqlibrary uqlibrary-{ELEMENT_NAME} && cd .. && rm -rf temp

* UQLibrary apps

UQLibrary apps use custom, core-, paper-, or other elements as building blocks for bigger application. To start apps development:

    # to create a new app
    $ git clone https://github.com/uqlibrary/uqlibrary-app-template.git
    
    # to modify existing element
    $ git clone https://github.com/uqlibrary/uqlibrary-{app-name}.git
    
    $ git clone https://github.com/uqlibrary/uqlibrary-elements.git
    
All dependencies for applications are located as vulcanized/combined files in /uqlibrary-element/v/lib/vulcanized.html (therefore, bower install is not required).

Any app specific styles should be added to uqlibrary-{app-name}.scss, if a style can be reused in other elements/apps, it should be added to common styles in uqlibrary-elements.

* PHPStorm IDE settings
Ensure that your SCSS File Watcher is configured to exclude recursively the uqlibrary-elements '0.5.4' directory or you will get SCSS compilation errors.

### Adding a component

When custom components are ready to be used in applications they are combined into a single file by the process of vulcanization (Read more details on https://github.com/polymer/vulcanize)

Install vulcanize tools:

    $ npm install -g vulcanize@0.7.1
    
Note: Polymer 0.5.x will only work with vulcanize version 0.7.1. If you want to upgrade to Polymer 1.0+ you can use vulcanize 1.8.1+, but only then.

To add a custom component, in path/to/uqlibrary-element/ add component as a dependency to the bower.json file:
```
    "uqlibrary-{custom-element}": "uqlibrary/uqlibrary-{custom-element}#<branch>"
```

Vulcanize is performed for 
* each branch (master/uat/staging/production)
* different applications:
    - index.html - for UQ Library My library applications 
    - index-flint.html - for UQ Library Voices application
    - if a new application requires a sub-set of custom elements, a new vulcanized config index.html file is created

Edit corresponding to the app vulcanized config (eg index.html) file in the root of the repo and include the component so it will be vulcanized.

Next run the elements.sh script in the bin directory locally, which will generate a vulcanized file that
can be included in your app:

    $ cd /path/to/uqlibrary-element
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
The uqlibrary-elements tests in sub-application build triggers only run the tests in Chrome on the Codeship VM, 
no matter what branch, with full browser test coverage staying on the uqlibrary-elements codeship build itself. 
This is done to speed up deployment of apps while keeping some level of safety net for the base aggregate of uqlibrary-elements.

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

At the moment most components have styling applied to them to look consistent within My Library and also within The University of Queensland style guidelines where available.

All sass files exist in the `/theme` directory, and each app that has it's own particular styles have their own corresponding sass file, so the Computer availability app has a `_computers.scss` file associated with it. Please make sure you keep your style changes contained within each respective file so when we eventually reduce the number of 'unique snowflakes' and have more completely reusable components.

`_variables.scss` is where all hardcoded values should go and be stored as variables with comments about why the particular values are chosen (e.g. `/* $touch-target-size is 44px because this is what human usability studies suggest is the minumum human touch target size */`). `_core.scss` is where core styles that apply across components should go, while others, such as `_buttons.scss` and `_margins.scss` describe the styles associated with those types of commonly-used structural elements.

### Accessibility Guidelines

Keyboard navigation issues and resolutions
* use on-click (on-tap is a gesture/mouse-only only, in Polymer v0.8 it might be fixed
* keyboard navigation with TAB (Option+TAB for Safari) is applicable only to links and form elements
* any items with an action need to have a link for keyboard navigation
    
```sh
  <!-- use on-click event on the container  -->
  <div class="content" on-click="{{ itemSelected }}" data-item-id="2">
    <!-- add a link for keyboard navigation, link is void and event is processed by on-click -->
    <div class="line1"><a href="javascript:;">Pharmaceutics : the science of dosage form design</a></div>
    <div class="line2">Barcode: 34067027831923</div>
    <div class="line3">Call Number: Q222 .T83 1990</div>
  </div>
``` 
* paper-item, paper-tab, etc are not keyboard accessible, as a solution use core-a11y-keys with link, example:
   
```sh
  <!-- keyboard events will be applied to tab -->
  <core-a11y-keys id="a11yFinesTab" 
    target="{{$.finesTab}}" 
    keys="enter space" 
    on-keys-pressed="{{tabFinesSelected}}"></core-a11y-keys>
  
  <paper-tab name="fines" id="finesTab">
    <!-- adding a link makes a tab accessible via key board -->
    <a href="javascript:;" layout vertical center>Overdue Charges</a>
  </paper-tab>
```

* for dynamically created clickable items (eg paper-tabs, clickable lists) use uqlibrary-a11y-link (since those can't be bound to a core-a11y-key dynamically)

```sh
<paper-tabs id="tabs" selected="{{ selectedTab }}" on-core-select="{{ tabSelected }}">
  <template repeat="{{ processedCourses as course }}">
  <!-- dynamically created tab -->
    <paper-tab name="{{ course.courseId }}" id="course{{course.courseId}}">
      <div class="menu">
        <!-- include uqlibrary-a11y-link to make paper-tab keyboard navigable -->
        <uqlibrary-a11y-link>{{ course.SUBJECT }}</uqlibrary-a11y-link>
      </div>
    </paper-tab>
  </template>
</paper-tabs>
```


### Styling Implementation Guidelines
 
1. Seperate elements use elements.css from uqlibrary-elements/resources/theme (e.g. uqlibrary-persistent-footer)
2. Element.css is excluded from vulcanization in vulcanize.conf
3. Grunt-text-replace runs to update path in vulcanized.html to point to relative element.css
4. Grunt predeploy task runs following commands (for staging and production environments):
  * cssmin - to minify element.css and application.css
  * file-rev - to include revision number in file names for *.js *.css and vulcanized.html
  * usemin - updates references to file-rev files
  
### Accessibililty Guidelines

1. Any clickable items should be accessible by keyboard with distinct focused state;
  * use core-a11y-keys or uqlibrary-a11y-link as helpers to enable keyboard navigation
2. Use meaningful aria-tags:
  * aria-label, aria-valuetext for sliders
  * aria-label for icons, text fields, drop down lists and other controls
  * aria-hidden for hidden elements
3. Check keyboard navigation with VoiceOver utility on in Safari. 


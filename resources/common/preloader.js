document.cookie = "UQLMockData=enabled";

function isIE() {
  var myNav = navigator.userAgent.toLowerCase();
  return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
}

function hasSession() {
  return document.cookie.indexOf("UQLID") >= 0 || document.cookie.indexOf("UQLMockData") >= 0;
}

if (!hasSession()){
  document.location.href = "https://www.library.uq.edu.au/uqlais/login?return=" + window.btoa(window.location.href);
}

if (!('registerElement' in document
  && 'createShadowRoot' in HTMLElement.prototype
  && 'import' in document.createElement('link')
  && 'content' in document.createElement('template'))) {
  // IE 8 and 9 throw errors if you try to include webcomponents.js, which prevents other user messages working
  if (!isIE() || isIE() > 9) {
    document.write('<script src="../uqlibrary-elements/0.5.4/webcomponentsjs/webcomponents.min.js"><\/script>');
  }
  document.write('<script type="text/javascript" src="../uqlibrary-elements/resources/common/jquery/dist/jquery.min.js"><\/script>');
  document.write('<script type="text/javascript" src="../uqlibrary-elements/resources/common/PgwBrowser/pgwbrowser.min.js"><\/script>');
}

window.addEventListener('polymer-ready', function() {
  if (document.getElementById('unsupportedBrowser')) {
    document.getElementById('loaderImage').style.display = 'none';
    document.body.removeChild(document.getElementById('unsupportedBrowser'));
  }
});

var $buoop = {
    vs: {i: 10, f: 15, o: 15, s: 7, c: 36},  // browser versions to notify
    reminder: 0,                   // after how many hours should the message reappear
    // 0 = show all the time
    onshow: function (infos) {
    },      // callback function after the bar has appeared
    onclick: function (infos) {
    },      // callback function if bar was clicked

    l: false,                       // set a language for the message, e.g. "en"
                                    // overrides the default detection
    test: false,                    // true = always show the bar (for testing)
    text: "Please upgrade to the latest version of <a href='http://www.google.com/chrome'>Google Chrome</a> to get the best experience on this site",                       // custom notification html text
    text_xx: "",                    // custom notification text for language "xx"
                                    // e.g. text_de for german and text_it for italian
    newwindow: true                 // open link in new window/tab
};

function $buo_f() {
    var e = document.createElement("script");
    e.src = "//browser-update.org/update.js";
    document.body.appendChild(e);
};

try {
    document.addEventListener("DOMContentLoaded", $buo_f, false)
    (function () {
        window.addEventListener('polymer-ready', function () {
          if (document.getElementById('unsupportedBrowser')) {
            document.getElementById('loader').style.display = 'none';
            document.getElementById('unsupportedBrowser').style.display = 'none';
          }
        });
    }());
}
catch (e) {
    if (window.jQuery) {
        $(document).ready(function () {
            var pgwBrowser = $.pgwBrowser();
            var messageCard = document.querySelector('#unsupportedBrowserSupportMessage');
            var e = document.createElement("p");
            e.id = "browserDetails";
            switch (pgwBrowser.os.group) {
                case 'iOS':
                    if (pgwBrowser.os.majorVersion < 6) {
                        e.innerHTML = '<br \/><br \/>You are currently using an unsupported version of Safari bundled with Apple iOS version ' + pgwBrowser.os.fullVersion + '. We can only support Safari in Apple iOS version 6 and above.'
                    }
                    break;
                case 'Windows Phone':
                    if (pgwBrowser.os.majorVersion < 8 && pgwBrowser.os.minorVersion < 1) {
                        e.innerHTML = '<br \/><br \/>You are currently using a version of Windows Phone older than version 8.1 (version ' + pgwBrowser.os.fullVersion + '). We can only support version 8.1 and above.'
                    }
                    break;
                case 'Android':
                    if (pgwBrowser.os.majorVersion < 4 && pgwBrowser.os.minorVersion < 4) {
                        e.innerHTML = '<br \/><br \/>Since you are using Android (version ' + pgwBrowser.os.fullVersion + ') you can upgrade from the old Android Browser to <a href=\'https:\/\/play.google.com\/store\/apps\/details?id=com.android.chrome&hl=en\'>Google Chrome for Android<\/a> to get a faster, and compatible web experience.';
                    }
                    break;
            }

            messageCard.appendChild(e);

        });
    }
    if (window.attachEvent) {
        window.attachEvent("onload", $buo_f);
    }
}
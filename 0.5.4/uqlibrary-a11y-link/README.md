uqlibrary-a11y-link
==================

Accessible version of a link located in on-tap area in case navigation is handled by Javascript.

In this case only mouse or touch events will be handled, eg if user navigates to a link with keyboard and hits ENTER or SPACE, tap event will not fire:
```sh
<div on-tap="{{tapHandler}}">
  <a href="javascript:;">Tap anywhere</a>
  <div> tap here too </div>
</div>
```

uqlibrary-a11y-link adds a11y keys to a link, and ENTER or SPACE key press event will trigger tap event:

```sh
<div on-tap="{{tapHandler}}">
  <uqlibrary-a11y-link>Tap anywhere</uqlibrary-a11y-link>
  <div> tap here too </div>
</div>
```

See the [component page](https://uqlibrary.github.io/uqlibrary-a11y-link) for more information.

## Testing Your Element

### web-component-tester

The tests are compatible with [web-component-tester](https://github.com/Polymer/web-component-tester). You can run them on multiple local browsers via:

```sh
npm install -g web-component-tester
wct
```

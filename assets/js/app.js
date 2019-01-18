// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import * as jsDiff from "diff"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

document.addEventListener('DOMContentLoaded', function () {
  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach(function ($el) {
      $el.addEventListener('click', function () {

        // Get the target from the "data-target" attribute
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }

  var toggleTabs = function(show, hide) {
    document.querySelector('.tabs ' + show).classList.add('is-active');
    hide.forEach(function(clz) {
      document.querySelector('.tabs ' + clz).classList.remove('is-active');
    });
  };

  var toggleCode = function(show, hide) {
    document.querySelector('.box ' + show).classList.remove('is-hidden');
    hide.forEach(function(clz) {
      document.querySelector('.box ' + clz).classList.add('is-hidden');
    });
  };

  var changeTab = function(e) {
    switch (e.target.innerHTML.toLowerCase()) {
      case 'diff':
        toggleTabs('.diff', ['.original', '.changes'])
        toggleCode('.diff', ['.original', '.changes'])
        break;
      case 'original':
        toggleTabs('.original', ['.diff', '.changes'])
        toggleCode('.original', ['.diff', '.changes'])
        break;
      case 'changes':
        toggleTabs('.changes', ['.original', '.diff'])
        toggleCode('.changes', ['.original', '.diff'])
        break;
    }
  };

  var $diff = document.querySelector('.box .diff');

  if ($diff) {
    var tabLinks = document.querySelectorAll('.tabs a');
    tabLinks.forEach(function(tab) {
      tab.addEventListener('click', changeTab);
    });

    var original = document.querySelector('.box .original').innerHTML,
      changes = document.querySelector('.box .changes').innerHTML,
      diff = jsDiff.diffChars(original, changes),
      fragment = document.createDocumentFragment();

    diff.forEach(function(part){
      var color;
      if (part.added) {
        color = 'green';
      } else if (part.removed) {
        color = 'red';
      } else {
        color = 'grey';
      }

      var span = document.createElement('span');
      span.style.color = color;
      span.appendChild(document.createTextNode(part.value));
      fragment.appendChild(span);
    });

    $diff.appendChild(fragment);
  }
});

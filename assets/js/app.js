// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

import "phoenix_html";
import * as jsDiff from "diff";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import InfiniteScroll from "./infinite_scroll";
// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

document.addEventListener("DOMContentLoaded", function () {
  let csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute("content");
  let liveSocket = new LiveSocket("/live", Socket, {
    params: {
      _csrf_token: csrfToken,
    },
    hooks: { InfiniteScroll: InfiniteScroll },
  });

  liveSocket.connect();

  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(
    document.querySelectorAll(".navbar-burger"),
    0
  );

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {
    // Add a click event on each of them
    $navbarBurgers.forEach(function ($el) {
      $el.addEventListener("click", function () {
        // Get the target from the "data-target" attribute
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle("is-active");
        $target.classList.toggle("is-active");
      });
    });
  }

  var toggleTabs = function (show, hide) {
    document.querySelector(".tabs " + show).classList.add("is-active");
    hide.forEach(function (clz) {
      document.querySelector(".tabs " + clz).classList.remove("is-active");
    });
  };

  var toggleCode = function (show, hide) {
    document.querySelector(".box " + show).classList.remove("is-hidden");
    hide.forEach(function (clz) {
      document.querySelector(".box " + clz).classList.add("is-hidden");
    });
  };

  var changeTab = function (e) {
    switch (e.target.innerHTML.toLowerCase()) {
      case "diff":
        toggleTabs(".diff", [".original", ".changes"]);
        toggleCode(".diff", [".original", ".changes"]);
        break;
      case "original":
        toggleTabs(".original", [".diff", ".changes"]);
        toggleCode(".original", [".diff", ".changes"]);
        break;
      case "changes":
        toggleTabs(".changes", [".original", ".diff"]);
        toggleCode(".changes", [".original", ".diff"]);
        break;
    }
  };

  var $diff = document.querySelector(".box .diff pre");

  if ($diff) {
    var tabLinks = document.querySelectorAll(".tabs a");
    tabLinks.forEach(function (tab) {
      tab.addEventListener("click", changeTab);
    });

    var original = document.querySelector(".box .original pre").innerHTML,
      changes = document.querySelector(".box .changes pre").innerHTML,
      diff = jsDiff.diffChars(original, changes),
      fragment = document.createDocumentFragment();

    diff.forEach(function (part) {
      var backgroundColor;
      if (part.added) {
        backgroundColor = "#acf2bd";
      } else if (part.removed) {
        backgroundColor = "#fdb8c0";
      } else {
        backgroundColor = "inherit";
      }

      var span = document.createElement("span");
      span.style.backgroundColor = backgroundColor;
      span.appendChild(document.createTextNode(part.value));
      fragment.appendChild(span);
    });

    $diff.appendChild(fragment);
  }

  var $companyTogglers = document.querySelectorAll(".toggle-company-actions");
  var $overlay = document.getElementById("overlay");
  $overlay.addEventListener("click", () => {
    $companyTogglers.forEach((toggler) => {
      toggler.parentElement.classList.toggle("show");
    });
    $overlay.style.display = "none";
  });

  if ($companyTogglers) {
    $companyTogglers.forEach(function (toggler) {
      toggler.addEventListener("click", function () {
        toggler.parentElement.classList.toggle("show");
        $overlay.style.display = "block";
      });
    });
  }

  var $localeItems = document.querySelectorAll(".locales .dropdown-item");

  if ($localeItems) {
    $localeItems.forEach(function (toggler) {
      toggler.addEventListener("click", function (event) {
        event.preventDefault();
        var parts = window.location.href.split("/");
        parts[3] = toggler.dataset.locale;
        window.location = parts.join("/");
      });
    });
  }
});

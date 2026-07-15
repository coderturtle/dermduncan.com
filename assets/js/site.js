// dermduncan.com — progressive enhancement only. The site is fully usable without
// this file: navigation falls back to an always-visible list on small screens only
// when JS is present (the toggle button is inert without it, so the menu is shown),
// and capability filtering falls back to showing every thread with anchor links.

(function () {
  "use strict";

  // Mobile navigation toggle.
  var toggle = document.querySelector(".nav-toggle");
  var menu = document.getElementById("nav-menu");
  if (toggle && menu) {
    toggle.addEventListener("click", function () {
      var open = menu.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && menu.classList.contains("is-open")) {
        menu.classList.remove("is-open");
        toggle.setAttribute("aria-expanded", "false");
        toggle.focus();
      }
    });
  }

  // Capability thread filtering.
  var filter = document.querySelector("[data-cap-filter]");
  if (!filter) return;

  var buttons = filter.querySelectorAll(".chip-button");
  var threads = document.querySelectorAll("[data-cap-thread]");
  var hint = document.querySelector("[data-cap-hint]");
  filter.hidden = false;
  if (hint) hint.hidden = false;

  function apply(capId) {
    buttons.forEach(function (b) {
      b.setAttribute("aria-pressed", b.getAttribute("data-cap") === capId ? "true" : "false");
    });
    var shown = 0;
    threads.forEach(function (t) {
      var match = capId === "all" || t.getAttribute("data-cap-thread") === capId;
      t.classList.toggle("is-hidden", !match);
      if (match) shown++;
    });
    if (hint) {
      hint.textContent = capId === "all"
        ? "Showing all " + threads.length + " capability threads."
        : "Showing 1 of " + threads.length + " threads. Every stage links to the chapter where it happened.";
    }
  }

  buttons.forEach(function (b) {
    b.addEventListener("click", function () {
      apply(b.getAttribute("data-cap"));
    });
  });

  // Deep links like /capabilities/#automation select that thread.
  var initial = window.location.hash.replace("#", "");
  var valid = Array.prototype.some.call(threads, function (t) {
    return t.getAttribute("data-cap-thread") === initial;
  });
  apply(valid ? initial : "all");
  window.addEventListener("hashchange", function () {
    var id = window.location.hash.replace("#", "");
    var ok = Array.prototype.some.call(threads, function (t) {
      return t.getAttribute("data-cap-thread") === id;
    });
    if (ok) apply(id);
  });
})();

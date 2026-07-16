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

  // Capability thread filtering (Capabilities page only).
  var filter = document.querySelector("[data-cap-filter]");
  if (filter) {
    var buttons = filter.querySelectorAll(".chip-button");
    var threads = document.querySelectorAll("[data-cap-thread]");
    var hint = document.querySelector("[data-cap-hint]");
    filter.hidden = false;
    if (hint) hint.hidden = false;

    var apply = function (capId) {
      buttons.forEach(function (b) {
        b.setAttribute("aria-pressed", b.getAttribute("data-cap") === capId ? "true" : "false");
      });
      threads.forEach(function (t) {
        var match = capId === "all" || t.getAttribute("data-cap-thread") === capId;
        t.classList.toggle("is-hidden", !match);
      });
      if (hint) {
        hint.textContent = capId === "all"
          ? "Showing all " + threads.length + " capability threads."
          : "Showing 1 of " + threads.length + " threads. Every stage links to the chapter where it happened.";
      }
    };

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
      if (!ok) return;
      apply(id);
      // A capability node in the map view links to this same hash; if the
      // map is the visible panel, switch to the list view so the filtered
      // thread the hash just selected is actually visible.
      var listPanel = document.querySelector('[data-view-panel="list"]');
      var mapPanel = document.querySelector('[data-view-panel="map"]');
      var toggle = document.querySelector("[data-view-toggle]");
      if (listPanel && mapPanel && listPanel.hidden) {
        listPanel.hidden = false;
        mapPanel.hidden = true;
        if (toggle) {
          toggle.querySelectorAll("[data-view]").forEach(function (b) {
            b.setAttribute("aria-pressed", b.getAttribute("data-view") === "list" ? "true" : "false");
          });
        }
      }
    });
  }

  // List / map view toggle (Capabilities page only).
  var viewToggle = document.querySelector("[data-view-toggle]");
  if (viewToggle) {
    viewToggle.hidden = false;
    var viewButtons = viewToggle.querySelectorAll("[data-view]");
    var panels = document.querySelectorAll("[data-view-panel]");
    var showView = function (v) {
      viewButtons.forEach(function (b) {
        b.setAttribute("aria-pressed", b.getAttribute("data-view") === v ? "true" : "false");
      });
      panels.forEach(function (p) {
        p.hidden = p.getAttribute("data-view-panel") !== v;
      });
    };
    viewButtons.forEach(function (b) {
      b.addEventListener("click", function () {
        showView(b.getAttribute("data-view"));
      });
    });
    showView("list");
  }

  // Capability compounding map: hover/focus a node to trace its connections.
  // Every node is a real <a>, so the map is a working diagram of links even
  // without this — this just adds the tracing highlight on top.
  document.querySelectorAll(".capability-map").forEach(function (svg) {
    var nodes = svg.querySelectorAll(".map-node");
    var edges = svg.querySelectorAll(".map-edge");

    var clear = function () {
      nodes.forEach(function (n) { n.classList.remove("is-active", "is-dimmed"); });
      edges.forEach(function (e) { e.classList.remove("is-active", "is-dimmed"); });
    };

    var activate = function (nodeEl) {
      clear();
      var key = nodeEl.getAttribute("data-node");
      var type = key.split(":")[0];
      var id = key.slice(type.length + 1);
      var escapedId = window.CSS && CSS.escape ? CSS.escape(id) : id.replace(/["\\\]]/g, "\\$&");
      var relatedEdges = svg.querySelectorAll(".map-edge[data-" + type + '="' + escapedId + '"]');
      var relatedIds = new Set([id]);
      relatedEdges.forEach(function (e) {
        e.classList.add("is-active");
        relatedIds.add(e.getAttribute("data-chapter"));
        relatedIds.add(e.getAttribute("data-cap"));
      });
      nodes.forEach(function (n) {
        var nid = n.getAttribute("data-node").split(":")[1];
        n.classList.add(relatedIds.has(nid) ? "is-active" : "is-dimmed");
      });
      edges.forEach(function (e) {
        if (!e.classList.contains("is-active")) e.classList.add("is-dimmed");
      });
    };

    nodes.forEach(function (n) {
      n.addEventListener("mouseenter", function () { activate(n); });
      n.addEventListener("focus", function () { activate(n); });
      n.addEventListener("mouseleave", clear);
      n.addEventListener("blur", clear);
    });
  });

  // Command-K jump palette.
  var paletteTrigger = document.querySelector("[data-palette-trigger]");
  var palette = document.getElementById("palette");
  if (palette) {
    var paletteInput = palette.querySelector("[data-palette-input]");
    var paletteList = palette.querySelector("[data-palette-results]");
    var dataEl = document.getElementById("palette-data");
    var items = [];
    try { items = JSON.parse(dataEl.textContent); } catch (e) { items = []; }
    var results = [];
    var activeIndex = -1;
    var lastFocused = null;
    var inertTargets = document.querySelectorAll(".site-header, main, .site-footer, .skip-link");

    var renderResults = function () {
      paletteList.innerHTML = "";
      results.slice(0, 8).forEach(function (item, i) {
        var li = document.createElement("li");
        li.id = "palette-item-" + i;
        li.className = "palette-item" + (i === activeIndex ? " is-active" : "");
        li.setAttribute("role", "option");
        li.setAttribute("aria-selected", i === activeIndex ? "true" : "false");
        var a = document.createElement("a");
        a.href = item.url;
        // Tabbing must not strand focus on a result: DOM focus stays on the
        // input, ArrowUp/ArrowDown move a virtual selection announced via
        // aria-activedescendant, and Enter/click both still navigate.
        a.tabIndex = -1;
        var t = document.createElement("span");
        t.className = "palette-item-title";
        t.textContent = item.title;
        a.appendChild(t);
        if (item.subtitle) {
          var s = document.createElement("span");
          s.className = "palette-item-sub";
          s.textContent = item.subtitle;
          a.appendChild(s);
        }
        li.appendChild(a);
        paletteList.appendChild(li);
      });
      paletteInput.setAttribute("aria-activedescendant", activeIndex >= 0 ? "palette-item-" + activeIndex : "");
    };

    var runFilter = function () {
      var q = paletteInput.value.trim().toLowerCase();
      results = !q ? items : items.filter(function (item) {
        return (item.title + " " + item.subtitle).toLowerCase().indexOf(q) !== -1;
      });
      activeIndex = results.length ? 0 : -1;
      renderResults();
    };

    var openPalette = function () {
      lastFocused = document.activeElement;
      palette.hidden = false;
      document.body.classList.add("palette-open");
      inertTargets.forEach(function (el) { el.inert = true; });
      paletteInput.value = "";
      runFilter();
      paletteInput.focus();
    };

    var closePalette = function () {
      palette.hidden = true;
      document.body.classList.remove("palette-open");
      inertTargets.forEach(function (el) { el.inert = false; });
      if (lastFocused) lastFocused.focus();
    };

    if (paletteTrigger) {
      paletteTrigger.hidden = false;
      paletteTrigger.addEventListener("click", openPalette);
    }

    document.addEventListener("keydown", function (e) {
      var meta = e.metaKey || e.ctrlKey;
      if (meta && e.key.toLowerCase() === "k") {
        e.preventDefault();
        if (palette.hidden) { openPalette(); } else { closePalette(); }
        return;
      }
      if (e.key === "/" && palette.hidden) {
        var tag = (document.activeElement && document.activeElement.tagName || "").toLowerCase();
        if (tag !== "input" && tag !== "textarea") {
          e.preventDefault();
          openPalette();
        }
      }
    });

    palette.addEventListener("mousedown", function (e) {
      if (e.target === palette) closePalette();
    });

    // Backstop: Escape closes the dialog regardless of which descendant has
    // focus, not just the input (result links keep tabIndex -1, but this
    // covers any other future focusable descendant too).
    palette.addEventListener("keydown", function (e) {
      if (e.key === "Escape") closePalette();
    });

    paletteInput.addEventListener("input", runFilter);
    paletteInput.addEventListener("keydown", function (e) {
      if (e.key === "Escape") {
        closePalette();
      } else if (e.key === "ArrowDown") {
        e.preventDefault();
        if (results.length) { activeIndex = (activeIndex + 1) % results.length; renderResults(); }
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        if (results.length) { activeIndex = (activeIndex - 1 + results.length) % results.length; renderResults(); }
      } else if (e.key === "Enter") {
        e.preventDefault();
        if (activeIndex >= 0 && results[activeIndex]) window.location.href = results[activeIndex].url;
      }
    });
  }
})();

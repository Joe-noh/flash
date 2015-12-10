// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "../shared/socket"
import Appender from "./appender"

class Flash {
  constructor(selector) {
    this.element = $(selector);
    this.colors = ["#fff", "#fff"];
    this.period = 500;
    this.colorPosition = 0;
    this.timeoutId;
  }

  setColor1(color) {
    this.colors[0] = color;
  }

  setColor2(color) {
    this.colors[1] = color;
  }

  setPeriod(period) {
    this.period = period;
  }

  colorChange(c, p) {
    this.colors = ["#fff", c];
    if (p) {
      this.period = p;
    }
  }

  restartAnimation() {
    window.clearTimeout(this.timeoutId);
    this.element.stop();
    this.element.css({ backgroundColor: "#fff" });
    this.colorPosition = 0;
    this.startAnimation();
  }

  startAnimation() {
    this.element.animate({ backgroundColor: this.colors[this.colorPosition] }, this.period);
    this.colorPosition++;
    if (this.colorPosition == this.colors.length) {
      this.colorPosition = 0;
    }
    this.timeoutId = window.setTimeout(
      () => { this.startAnimation() },
      this.period
    );
  }
}

let noSleep = new NoSleep();
let channel = socket.channel("rooms:lobby", {operator: false});
let appender = new Appender($('#log'));

const flash = new Flash('body');

$(document).ready(() => {
  channel.on("color:change", (params) => {
    console.log(params);

    // flash.colorChange(params.code, params.period);
    // flash.restartAnimation();

    $('#board').css('background-color', params.code);
    appender.append(params.code);
  });

  channel.on("color:sync", () => {
    flash.restartAnimation();
  });

  channel.on("opacity:change", (params) => {
    console.log(params);
    $('#board').css('opacity', params.opacity);
  });

  channel.on("ping", () => {
    channel.push("pong", {});
    console.log("got ping. replied pong");
  });

  channel.on("current", (params) => {
    // 現在の指示
    console.log(params);

    channel.push("current:ok", {});
  });

  channel.join()
    .receive("ok",    (resp) => { console.log("Joined successfully"); })
    .receive("error", (resp) => { console.log("Unable to join", resp) });
});

function enableNoSleep() {
  $('#start-button').removeEventListener('touchstart', enableNoSleep, false);
}

$('#start-button').click((e) => {
  $(e.target).hide();

  // flash.restartAnimation();

  noSleep.enable();
});

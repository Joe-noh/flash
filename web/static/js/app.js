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

import socket from "./socket"
import Appender from "./appender"

class Flash {
  constructor() {
    this.colors = ["#fff", "#fff"];
    this.period = 500;
    this.colorPosition = 0;
    this.timeoutId;
  }

  colorChange(c, p) {
    this.colors = ["#fff", c];
    this.period = p;
  }

  restartAnimation() {
    window.clearTimeout(this.timeoutId);
    $('body').stop();
    $('body').css({ backgroundColor: "#fff" });
    this.colorPosition = 0;
    this.startAnimation();
  }

  startAnimation() {
    $('body').animate({ backgroundColor: this.colors[this.colorPosition] }, this.period);
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

class Alarm {
  constructor(flash) {
    this.flash = flash;
    this.triggerTime = null;
    this.nextColor;
    this.nextPeriod;
  }

  register(unixtime) {
    this.triggerTime = unixtime;
    this.tick();
  }

  set(code, period) {
    this.nextColor  = code;
    this.nextPeriod = period;
  }

  tick() {
    if (this.triggerTime == null) { return; }

    const now = Math.floor(new Date().getTime() / 1000);

    if (this.triggerTime < now) {
      this.flash.colorChange(this.nextColor, this.nextPeriod);
      this.flash.restartAnimation();
    } else {
      console.log(this.triggerTime - now);
      window.setTimeout(() => { this.tick() }, 50);
    }
  }
}

let noSleep = new NoSleep();
let channel = socket.channel("rooms:lobby", {});
let appender = new Appender($('body'));

$(document).ready(() => {
  const flash = new Flash();
  const alarm = new Alarm(flash);
  alarm.tick();

  channel.on("color:change", (params) => {
    console.log(params);

    // flash.colorChange(params.code, params.period);
    // flash.restartAnimation();

    $('body').css('background-color', params.code);
    appender.append(params.code);
  });

  channel.on("color:sync", () => {
    flash.restartAnimation();
  });

  channel.on("timestamp", (params) => {
    console.log(params);
    alarm.set(params.code, params.period);
    alarm.register(params.unixtime);
  });

  channel.join()
    .receive("ok", (resp) => {
      console.log("Joined successfully");
    })
    .receive("error", resp => { console.log("Unable to join", resp) });
});

function enableNoSleep() {
  $('#start-button').removeEventListener('touchstart', enableNoSleep, false);
}

$('#start-button').click((e) => {
  $(e.target).hide();

  noSleep.enable();
  channel.push("ping", {});
});

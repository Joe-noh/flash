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

$(document).ready(() => {
  const flash = new Flash();
  const channel = socket.channel("rooms:lobby", {});

  channel.on("color:change", (params) => {
    console.log(params);

    flash.colorChange(params.code, params.period);
    flash.restartAnimation();
  });

  channel.on("color:sync", () => {
    flash.restartAnimation();
  });

  channel.join()
    .receive("ok", (resp) => {
      console.log("Joined successfully");

      flash.colorChange(resp.code, resp.period);
    })
    .receive("error", resp => { console.log("Unable to join", resp) });

  flash.startAnimation();
});

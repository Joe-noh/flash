import "deps/phoenix_html/web/static/js/phoenix_html";

import socket from "../shared/socket";
import Cyalume from "./cyalume";
import Slider from "./slider";
import Circle from "./circle";
import Snow from "./snow";
import MerryChristmas from "./merry_christmas";

let channel = socket.channel("rooms:lobby", {operator: false});

let noSleep = new NoSleep();
let cyalume = new Cyalume("#screen");
let shade   = new Cyalume("#shade");
let slider  = new Slider(".slide1", ".slide2");
let circle  = new Circle("#circle", "#screen");
let snow    = new Snow("#snow");

let applyFlash = (params) => {
  switch(params.type) {
  case "fade":
    cyalume.fades(params.color, params.duration);
    break;
  case "switch":
    cyalume.switches(params.color);
    break;
  case "switch_random":
    snow.fallStart();
    cyalume.switchesRandomly(params.colors);
    circle.getAway();
    break;
  case "rainbow":
    cyalume.rainbows();
    break;
  case "shade":
    shade.shades(params.duration);
    break;
  case "slide":
    slider.slide(params.color, params.duration);
    break;
  case "circle":
    circle.spawn(params.color, params.duration);
    slider.getAway();
    break;
  default:
    console.log("unsupported message", params);
  }
};

$(document).ready(() => {
  new MerryChristmas().print_message();

  cyalume.switches('#101010');
  shade.switches('#101010');
  shade.transparent();

  channel.on("current", (params) => {
    $("#please-wait").hide();

    applyFlash(params);

    channel.push("current:ok", {});
  });

  channel.join()
    .receive("ok", (resp) => {
      if (window.env == 'dev') {
        console.log("Joined successfully");
        console.log(resp);
      }
    })
    .receive("error", (resp) => {
      if (window.env == 'dev') {
        console.log("Unable to join", resp);
      }
    });
});

function enableNoSleep() {
  $('#start-button').removeEventListener('touchstart', enableNoSleep, false);
}

$('#start-button').click((e) => {
  $(e.target).hide();
  $("#please-wait").show();
  noSleep.enable();
});

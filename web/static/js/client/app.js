import "deps/phoenix_html/web/static/js/phoenix_html";

import socket from "../shared/socket";
import Cyalume from "./cyalume";

let channel = socket.channel("rooms:lobby", {operator: false});

let noSleep = new NoSleep();
let cyalume = new Cyalume("body");

let applyFlash = (params) => {
  switch(params.type) {
  case "fade":
    cyalume.fades(params.color, params.duration);
    break;
  case "switch":
    cyalume.switches(params.color);
    break;
  case "rainbow":
    cyalume.rainbows();
    break;
  default:
    console.log("unsupported message", params);
  }
};

$(document).ready(() => {
  cyalume.switches('#101010');

  channel.on("current", (params) => {
    $("#please-wait").hide();
    console.log(params);

    applyFlash(params);

    channel.push("current:ok", {});
  });

  channel.join()
    .receive("ok", (resp) => {
      console.log("Joined successfully");
      console.log(resp);
    })
    .receive("error", (resp) => { console.log("Unable to join", resp) });
});

function enableNoSleep() {
  $('#start-button').removeEventListener('touchstart', enableNoSleep, false);
}

$('#start-button').click((e) => {
  $(e.target).hide();
  $("#please-wait").show();
  noSleep.enable();
});

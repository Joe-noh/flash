import "deps/phoenix_html/web/static/js/phoenix_html";

import socket from "../shared/socket";
import Cyalume from "./cyalume";

let channel = socket.channel("rooms:lobby", {operator: false});

let noSleep = new NoSleep();
let cyalume = new Cyalume('body');

$(document).ready(() => {
  channel.on("current", (params) => {
    console.log(params);

    switch(params.type) {
    case "fade":
      cyalume.fades(params.color, params.code);
      break;
    case "switch":
      cyalume.switches(params.color);
      break;
    case "rainbow":
      cyalume.rainbow();
      break;
    default:
      console.log("unsupported message", params);
    }

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

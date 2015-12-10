import "deps/phoenix_html/web/static/js/phoenix_html";

import socket from "../shared/socket";

let channel = socket.channel("rooms:lobby", {operator: true});

$(document).ready(() => {
  channel.on('current', (params) => {
    console.log(params);

    channel.push('current:ok', {});
  });

  channel.on("recipe", (recipe) => {
    console.log(recipe);
  });

  channel.on("start:ok", () => {
    console.log("started");
  });

  channel.join()
    .receive("ok",    (resp) => { console.log("Joined successfully"); })
    .receive("error", (resp) => { console.log("Unable to join", resp) });
});

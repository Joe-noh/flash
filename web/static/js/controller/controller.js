import "deps/phoenix_html/web/static/js/phoenix_html";

import socket from "../shared/socket";

let channel = socket.channel("rooms:lobby", {});

$(document).ready(() => {
  channel.join()
    .receive("ok", (resp) => {
      console.log("Joined successfully");
    })
    .receive("error", resp => {
      console.log("Unable to join", resp)
    });

  $('#ping').click((e) => {
    e.preventDefault();

    channel.push("ping:all", {});
  });

  $('#color-code-button').click((e) => {
    e.preventDefault();

    let code = $('#color-code').val();
    channel.push("color:change", {code: code});
  });

  $('#opacity-range').on('input', (e) => {
    let opacity = e.target.value / 100;
    console.log(opacity);
    channel.push("opacity:change", {opacity: opacity});
  });
});

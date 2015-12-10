import "deps/phoenix_html/web/static/js/phoenix_html";

import socket from "../shared/socket";

let channel = socket.channel("rooms:lobby", {operator: true});

$(document).ready(() => {
  channel.on("current", (params) => {
    console.log(params);

    channel.push("current:ok", {});
  });

  channel.on("scores", (recipe) => {
    console.log(recipe);
  });

  channel.on("start:ok", () => {
    console.log("started");
  });

  channel.join()
    .receive("ok", (scores) => {
      scores.forEach((score, index) => {
        let start_at = Math.floor(score.start_at / 1000)
        let min = Math.floor(start_at / 60);
        let sec = (start_at % 60);

        let detail = score.detail;

        let row = $("<li>")
          .text(`${min}:${sec} ${detail.type} ${detail.color}`)
          .data("offset", index)
          .on("click", (e) => {
            let offset = $(e.target).data("offset");
            console.log(offset, "からリスタート");
            channel.push("start", {offset: offset});
          });
        $("#scores").append(row);
      });
    })
    .receive("error", (resp) => { console.log("Unable to join", resp) });
});

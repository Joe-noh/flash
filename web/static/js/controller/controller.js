import "deps/phoenix_html/web/static/js/phoenix_html";

import socket from "../shared/socket";

let channel = socket.channel("rooms:lobby", {operator: true});

let extractStartAt = (score) => {
  let start_at = Math.floor(score.start_at / 1000)

  let min = Math.floor(start_at / 60);
  let sec = (start_at % 60) + "";
  if (sec.length == 1) { sec = "0"+sec; }

  return `${min}:${sec}`;
};

let extractColor = (score) => {
  let color = score.detail.color;
  if (color === undefined) { color = "-"; }

  return color;
};

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
        let time  = extractStartAt(score);
        let type  = score.detail.type;
        let color = extractColor(score);

        let html = `<tr align="right" data-offset="${index}">
            <td>${time}</td>
            <td>${type}</td>
            <td class="color-cell" style="background-color: ${color}">
              <span>${color}</span>
            </td>
          </tr>`;

        $("#scores").append($(html));
      });
    })
    .receive("error", (resp) => { console.log("Unable to join", resp) });

  $("#scores").on("click tap", "td", (e) => {
    let offset = $(e.target).parent().data("offset");
    console.log(`${offset}からリスタート`);
    channel.push("start", {offset: offset});
  });

  $("#stop-button").on("click", (e) => {
    console.log("ストップ！");
    channel.push("stop", {});
  });
});

class Snow {
  constructor(selector) {
    this.dom = $(selector);
    this.dom.css('opacity', 0);
    this.dom.hide();
    this.started = false;
  }

  fallStart() {
    if (this.started) { return; }

    this.started = true;
    this.dom.show();
    this.dom.velocity({opacity: 1}, 10000);
  }
}

export default Snow;

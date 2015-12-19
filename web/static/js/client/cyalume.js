class Cyalume {
  constructor(selector) {
    this.dom = $(selector);
  }

  fades(colorCode, duration) {
    this._cancel();
    this.dom.animate({backgroundColor: colorCode}, duration);
  }

  switches(colorCode) {
    this._cancel();
    this.dom.css('backgroundColor', colorCode);
  }

  rainbows() {
    this._cancel();
    this.dom.addClass('rainbow');
  }

  _cancel() {
    this.dom.stop();
    this.dom.removeClass();
  }
};

export default Cyalume;

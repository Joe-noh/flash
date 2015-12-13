class Cyalume {
  constructor(selector) {
    this.dom = $(selector);
  }

  fades(colorCode, period) {
    this.dom.removeClass();
    this.dom.stop();
    this.dom.animate({backgroundColor: colorCode}, period);
  }

  switches(colorCode) {
    this.dom.removeClass();
    this.dom.stop();
    this.dom.css('backgroundColor', colorCode);
  }

  rainbow() {
    this.dom.removeClass();
    this.dom.stop();
    this.dom.addClass('rainbow');
  }
};

export default Cyalume;

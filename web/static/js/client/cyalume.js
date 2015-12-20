Array.prototype.diff = function(a) {
  return this.filter(function(i) {return a.indexOf(i) < 0;});
};

class Cyalume {
  constructor(selector) {
    this.dom = $(selector);
    this.currentColor = "";
  }

  fades(colorCode, duration) {
    this._cancel();
    this.currentColor = colorCode;
    this.dom.animate({backgroundColor: colorCode}, duration);
  }

  switches(colorCode) {
    this._cancel();
    this.currentColor = colorCode;
    this.dom.css('backgroundColor', colorCode);
  }

  switchesRandomly(colors) {
    let color = this._randomPickup(colors);
    this.switches(color);
  }

  rainbows() {
    this._cancel();
    this.dom.addClass('rainbow');
  }

  _cancel() {
    this.dom.stop();
    this.dom.removeClass();
  }

  // colorsから適当に取るが、currentColorと同じものは取らない
  _randomPickup(colors) {
    let cs = colors.filter((elem) => {
      return (elem != this.currentColor);
    }, this);
    console.log(cs);
    let index = Math.floor(Math.random() * cs.length);

    return cs[index];
  }
};

export default Cyalume;

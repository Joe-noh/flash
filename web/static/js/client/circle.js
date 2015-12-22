class Circle {
  constructor(circleSelector, backSelector) {
    this.circleDom = $(circleSelector);
    this.backDom   = $(backSelector);
  }

  spawn(color, duration) {
    this.circleDom.css('width',  '0%');
    this.circleDom.css('height', '0%');

    let body = $('body');
    let height = body.height();
    let width  = body.width();

    let larger = ((height > width) ? height : width) * 2;

    let initTop  = this._random(0.85*height, 0.15*height);
    let initLeft = this._random(0.85*width,  0.15*width);

    this.circleDom.css('top',  initTop);
    this.circleDom.css('left', initLeft);

    this.circleDom.css('backgroundColor', color);
    this.circleDom.velocity({
      width:  larger,
      height: larger,
      top:    initTop - larger/2,
      left:   initLeft - larger/2
    }, duration, () => {
      this.backDom.css('backgroundColor', color);
    });
  }

  _random(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
  }
}

export default Circle;

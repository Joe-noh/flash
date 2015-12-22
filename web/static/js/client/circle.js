class Circle {
  constructor(circleSelector, backSelector) {
    this.circleDom = $(circleSelector);
    this.backDom   = $(backSelector);
  }

  spawn(color, duration) {
    this.circleDom.css('width',  '0%');
    this.circleDom.css('height', '0%');

    let height = $('body').height();
    let width  = $('body').width();

    let larger = ((height > width) ? height : width) * 2;

    let initTop  = height / 4;
    let initLeft = width / 3;

    this.circleDom.css('top',  initTop);
    this.circleDom.css('left', initLeft);

    this.circleDom.css('backgroundColor', color);
    this.circleDom.velocity({width: larger, height: larger, top: initTop - larger/2, left: initLeft - larger/2}, duration);
  }
}

export default Circle;

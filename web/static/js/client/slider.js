class Slider {
  constructor(horizontal, vertical) {
    this.domH = $(horizontal);
    this.domV = $(vertical);
    this.domV.css('z-index', 8);
    this.state = 0;
  }

  slide(color, duration) {
    switch(this.state) {
      case 0:
      case 4:
        this.state = 1;
        this.domH.css('background-color', color);
        this.domH.css('z-index', 9);
        this.domH.css('width', '0%');
        this.domH.velocity({width: '100%'}, duration, "ease-out");
        break;
      case 1:
        this.state = 2;
        this.domV.css('background-color', color);
        this.domV.css('height', '100%');
        this.domH.velocity({width: '0%'}, duration, "ease-out");
        break;
      case 2:
        this.state = 3;
        this.domH.css('z-index', 7);
        this.domH.css('width', '100%');
        this.domH.css('background-color', color);
        this.domV.velocity({height: '0%'}, duration, "ease-out");
        break;
      case 3:
        this.state = 4;
        this.domV.css('background-color', color);
        this.domV.css('height', '0%');
        this.domV.velocity({height: '100%'}, duration, "ease-out");
        break;
    }
  }

  getAway() {
    this.domH.hide();
    this.domV.hide();
  }
}

export default Slider;

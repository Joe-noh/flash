class Appender {
  constructor(dom) {
    this.dom = dom;
    this.container = $('<div></div>');
  }

  append(dom) {
    this.dom.append(dom);
  }
}

export default Appender;

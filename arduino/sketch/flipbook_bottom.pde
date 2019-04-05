public class Bottom extends Flipbook {

  Bottom(PApplet parent, char id, int x, int y) { super(parent, id, x, y, parent.width, parent.height / 2); }
  Bottom(PApplet parent, char id, int x, int y, int w, int h) { super(parent, id, x, y, w, h); }

  // -------------------------------------------------------------------------

  int x, y, width, height;

  void setup() {
    textSize(80);
    textAlign(CENTER, CENTER);
  }

  void draw() {
    super.background(super.frameCount % 255);

    fill(255);
    // text(super.frameCount + "\n(" + super.frameRate + ")", super.width / 2, super.y + super.height / 2);
    text(super.frameCount, super.width / 2, super.y + super.height / 2);
  }

}
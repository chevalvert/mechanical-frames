public class Bottom extends Flipbook {

  Bottom(PApplet parent, char id, int x, int y) { super(parent, id, x, y, parent.width, parent.height / 2); }
  Bottom(PApplet parent, char id, int x, int y, int w, int h) { super(parent, id, x, y, w, h); }

  // -------------------------------------------------------------------------

  int x, y, width, height;

  void setup() {
    textSize(40);
    textAlign(CENTER, CENTER);
  }

  void draw() {
    super.background(super.frameCount % 255);

    fill(200, 0, 100);
    text(super.frameCount + "\n(" + super.frameRate + ")", super.width / 2, super.y + super.height / 2);
  }

}
public class Test extends Flipbook {

  public int x, y, width, height;

  Test(char id, int x, int y, int w, int h) {
    super(id, x, y, w, h);

    textSize(40);
    textAlign(CENTER, CENTER);
  }

  // -------------------------------------------------------------------------

  void draw() {
    noStroke();
    fill(super.frameCount % 255);
    rect(super.x, super.y, super.width, super.height);

    fill(200, 0, 100);
    text(super.frameCount, super.width / 2, super.y + super.height / 2);
  }

}
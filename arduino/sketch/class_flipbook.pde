public abstract class Flipbook {
  public PApplet parent;

  public char ID;
  public int
  x, y, width, height,
  frameRate = 0,
  frameCount = 0;

  Flipbook(char id, int x, int y, int w, int h) {
    this.ID = id;
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
  }

  // -------------------------------------------------------------------------

  public Flipbook update(String s) {
    if (s != null) {
      if (s.charAt(0) == this.ID) {
        if (s.charAt(1) == '0') {
          this.frameCount++;
          this.draw();
        }
      }
    }

    return this;
  }


  // -------------------------------------------------------------------------

  abstract void draw();

}
public abstract class Flipbook {
  public PApplet parent;

  public char ID;
  public int
    x, y, width, height,
    frameCount = 0,
    frameRate = 10;

  Flipbook(PApplet parent, char id, int x, int y, int w, int h) {
    this.parent = parent;
    this.ID = id;
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;

    this.setup();
  }

  // -------------------------------------------------------------------------

  public void update(String s) {
    if (s != null) {
      if (s.charAt(0) == this.ID) {
        if (s.charAt(1) == '0') {
          this.frameCount++;
          this.updateFrameRate();
          this.draw();
        }
      }
    }
  }

  private float lastTick = -1;
  private void updateFrameRate() {
    float currentTick = millis() * 0.001;
    this.frameRate = int(1 / (currentTick - lastTick));
    lastTick = currentTick;
  }

  public void background(color c) {
    pushStyle();
      noStroke();
      fill(c);
      rect(this.x, this.y, this.width, this.height);
    popStyle();
  }

  // -------------------------------------------------------------------------

  abstract void setup();
  abstract void draw();

}
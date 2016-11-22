public class Node{

  private PVector POSITION;
  private PVector CENTER;
  private float RADIUS;
  private float SPEED;
  private float OFFSET;

  private int BEHAVIOR = 5;

  public Node(float x, float y) {
    this(x, y, 0, 0, 0);
  }

  public Node(float x, float y, float radius, float speed, float offset) {
    this.POSITION = new PVector(x, y);
    this.BEHAVIOR = int(random(0, 10));

    this.CENTER = new PVector(x, y);
    this.RADIUS = radius;
    this.SPEED = speed * (0.5 + norm(
                              constrain(this.RADIUS + this.CENTER.x, 0, width / 2),
                              0, width / 2));
    this.OFFSET = offset;
  }


  public void update() {
    switch (this.BEHAVIOR) {
      case 0 :
        this.POSITION.x = this.CENTER.x + sin(sin(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        this.POSITION.y = this.CENTER.y + cos(cos(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        break;
      case 1 :
        this.POSITION.x = this.CENTER.x + sin(cos(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        this.POSITION.y = this.CENTER.y + cos(sin(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        break;
      case 2 :
        this.POSITION.x = this.CENTER.x + sin(cos(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        this.POSITION.y = this.CENTER.y + cos(cos(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        break;
      case 3 :
        this.POSITION.x = this.CENTER.x + sin(sin(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        this.POSITION.y = this.CENTER.y + cos(sin(frameCount * this.SPEED + this.OFFSET)) * this.RADIUS;
        break;
      case 4 :
        this.POSITION.x = this.CENTER.x + sin(frameCount * this.SPEED + sin(frameCount * this.SPEED) * this.OFFSET) * this.RADIUS;
        this.POSITION.y = this.CENTER.x + sin(frameCount * this.SPEED + sin(frameCount * this.SPEED) * this.OFFSET) * this.RADIUS;
      case 5 :
        this.POSITION.x = this.CENTER.x + noise(frameCount * this.SPEED, this.OFFSET) * this.RADIUS;
        this.POSITION.y = this.CENTER.y + noise(this.OFFSET, frameCount * this.SPEED) * this.RADIUS;
      default :
        this.POSITION.x = this.CENTER.x + sin(frameCount * this.SPEED + this.OFFSET) * this.RADIUS;
        this.POSITION.y = this.CENTER.y + cos(frameCount * this.SPEED + this.OFFSET) * this.RADIUS;

    }

    if (DEBUG_CONTRAINED) {
      this.POSITION.x = constrain(this.POSITION.x, margin, width / 2);
      this.POSITION.y = constrain(this.POSITION.y, margin, height - margin);
    }
  }


  public PVector getPosition() { return this.POSITION; }
}
public class Insect extends Flipbook {
  Node[] nodes;
  int margin = 10;
  boolean DEBUG_CONTRAINED = true;

  Insect(char id, int x, int y, int w, int h) {
    super(id, x, y, w, h);

    int r = int(random(4, 8)); // 12
    Node[] _nodes = new Node[r];

    _nodes[0] = new Node(super.width / 2, random(margin, super.height / 2 - margin * 2));
    for (int i = 1; i < r - 1; i++) _nodes[i] = new Node(random(super.width / 2), random(super.height / 2), random(100), 0.1, random(PI));
    _nodes[r - 1] = new Node(super.width / 2, random(super.height / 2 + margin * 2, super.height - margin));
    nodes = _nodes;
  }

  // -------------------------------------------------------------------------

  void draw() {
    pushMatrix();
    for (Node n : nodes) n.update();
    background(0);

    translate(0, sin(frameCount * 0.05) * margin / 4);

    stroke(50); strokeWeight(1); noFill();
    beginShape();
    for (Node n : nodes) vertex(n.getPosition().x, n.getPosition().y);
    endShape();

    // SYMMETRY
    beginShape();
    for (Node n : nodes) vertex(super.width - n.getPosition().x, n.getPosition().y);
    endShape();

    // WEB
    float d_threshold = map(mouseX, 0, super.width, 0, 1) * 1000;
    stroke(255);
    for (Node p : nodes) {
      for (Node n : nodes) {
        if (p != n) {
          PVector a = p.getPosition();
          PVector b = n.getPosition();
          float d = a.dist(b);
          if (d < d_threshold) {
            stroke(255, map(d, 0, d_threshold, 255, 0));
            strokeWeight(map(d, 0, d_threshold, 10, 1));
            line(a.x, a.y, b.x, b.y);
            line(super.width - a.x, a.y, super.width - b.x, b.y);
          }
        }
      }
    }
    popMatrix();
  }

  // -------------------------------------------------------------------------

  private class Node{
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

}
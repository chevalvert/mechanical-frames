boolean DEBUG_CONTRAINED = true;

Node[] nodes;
float radius = 100;
int margin = 100;

void settings() {
  fullScreen(P2D);
  // size(800, 800, P2D);
}

void setup() {
  int r = int(random(4, 8));
  // int r = 12;
  Node[] _nodes = new Node[r];

  _nodes[0] = new Node(width / 2, random(margin, height / 2 - margin * 2));
  for (int i = 1; i < r - 1; i++) {
    _nodes[i] = new Node(random(width / 2), random(height / 2), random(radius), 0.1, random(PI));
  }
  _nodes[r - 1] = new Node(width / 2, random(height / 2 + margin * 2, height - margin));

  nodes = _nodes;
}

void draw() {
  for (Node n : nodes) n.update();
  background(0);

  translate(0, sin(frameCount * 0.05) * margin / 4);


  stroke(50);
  strokeWeight(1);
  noFill();
  beginShape();


  for (Node n : nodes) vertex(n.getPosition().x, n.getPosition().y);
  endShape();
  // SYMMETRY
  beginShape();
  for (Node n : nodes) vertex(width - n.getPosition().x, n.getPosition().y);
  endShape();

  // WEB
  float d_threshold = map(mouseX, 0, width, 0, 1) * 1000;
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
          line(width - a.x, a.y, width - b.x, b.y);
        }
      }
    }
  }

}

void keyPressed() {
  if (key == 'r') setup();
  else if (key == 'c') DEBUG_CONTRAINED = !DEBUG_CONTRAINED;
}
public class Sphere extends Flipbook {
  int cols, rows;
  int scl = 20;
  int w = 500;
  int h = 500;

  float flying = 0;

  float[][] terrain;

  Sphere(char id, int x, int y, int w, int h) {
    super(id, x, y, w, h);

    cols = w / scl;
    rows = h / scl;

    terrain = new float[cols][rows];

    flying -= 0.1;
    float yoff = flying;
    for (int _y = 0; _y < rows; _y++) {
      float xoff = 0;
      for (int _x = 0; _x < cols; _x++) {
        terrain[_x][_y] = map(noise(xoff, yoff), 0, 1, -100, 100);
        xoff += 0.2;
      }
      yoff += 0.2;
    }
  }

  // -------------------------------------------------------------------------

  void draw() {
    pushMatrix();
    translate(super.x + super.width / 2, super.y + super.height * 1.5, -2000);
    rotateX(PI/2);
    int offset = int(frameCount * 0.3);

    stroke(255);
    strokeWeight(1);
    fill(0);
    for (int v = 0; v < rows - 1; v += 1) {
      beginShape(TRIANGLE_STRIP);
      for (int u = 0; u < cols; u += 1) {
        PVector a = toSphere(u, v);
        PVector b = toSphere(u, v + 1);
        vertex(a.x, a.y, a.z, norm(u, 0, cols), norm(v, 0, rows - 1));
        vertex(b.x, b.y, b.z, norm(u, 0, cols), norm(v + 1, 0, rows - 1));
      }
      endShape(CLOSE);
    }

    stroke(255);
    strokeWeight(6);
    noFill();
    for (int v = 0; v < map(mouseX, 0, width, 0, 1) * 10; v++) {
      beginShape();
      for (int u = 0; u < cols; u++) {
        PVector a = toSphere(u, (v + offset) % (rows - 1));
        vertex(a.x, a.y, a.z + 0.1);
      }
      endShape(CLOSE);
    }
    popMatrix();
  }

  // -------------------------------------------------------------------------

  PVector toSphere(int u, int v) {
    float theta = map(u, 0, cols - 1, 0, TWO_PI) + frameCount * 0.01;
    float phi = map(v, 0, rows - 1, 0, PI) + 0;
    float x = cos(theta) * sin(phi) * (500 + terrain[u][v]);
    float y = sin(theta) * sin(phi) * (500 + terrain[u][v]);
    float z = cos(phi) * 500;

    return new PVector(x, y, z);
  }
}
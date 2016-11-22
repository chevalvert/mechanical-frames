import peasy.*;
PeasyCam cam;

int cols, rows;
int scl = 20;
int w = 500;
int h = 500;

float flying = 0;

float[][] terrain;

void settings() {
  // fullScreen(P3D);
  size(1000, 600, P3D);
}

void setup() {
  cols = w / scl;
  rows = h / scl;

  terrain = new float[cols][rows];

  flying -= 0.1;
  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
      xoff += 0.2;
    }
    yoff += 0.2;
  }

  cam = new PeasyCam(this, 1000);
}

void draw() {
  surface.setTitle(int(frameRate) + " fps");

  background(0);
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
}

PVector toSphere(int u, int v) {
  float theta = map(u, 0, cols - 1, 0, TWO_PI) + frameCount * 0.01;
  float phi = map(v, 0, rows - 1, 0, PI) + 0;
  float x = cos(theta) * sin(phi) * (500 + terrain[u][v]);
  float y = sin(theta) * sin(phi) * (500 + terrain[u][v]);
  float z = cos(phi) * 500;

  return new PVector(x, y, z);
}
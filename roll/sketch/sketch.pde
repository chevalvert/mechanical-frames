import peasy.*;
PeasyCam cam;

int cols, rows;
int scl = 20;
int w = 2000;
int h = 2000;

float flying = 0;

float[][] terrain;

void settings() {
  fullScreen(P3D);
  // size(800, 800, P3D);
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

  cam = new PeasyCam(this, 300);
}

void draw() {
  background(0);

  rotateX(PI/2);
  rotateZ(PI/2);
  int offset = int(frameCount * 0.03);

  stroke(50);
  strokeWeight(1);
  fill(0);
  for (int v = 0; v < rows - 1; v++) {
    beginShape(TRIANGLE_STRIP);
    for (int u = 0; u < cols; u++) {
      PVector a = toCylinder(u, v);
      PVector b = toCylinder(u, v + 1);

      vertex(a.x, a.y, a.z, norm(u, 0, cols), norm(v, 0, rows - 1));
      vertex(b.x, b.y, b.z, norm(u, 0, cols), norm(v + 1, 0, rows - 1));
    }
    endShape();
  }

  stroke(255);
  strokeWeight(6);
  noFill();
  for (int v = 0; v <  map(mouseX, 0, width, 0, 1) * 10; v++) {
    beginShape();
    for (int u = 0; u < cols; u++) {
      PVector a = toCylinder(u, (v + offset) % (rows -1));
      vertex(a.x, a.y, a.z);
    }
    endShape();
  }
}

PVector toCylinder(int u, int v) {
  float theta = map(v, 0, rows - 1, 0, TWO_PI);
  float x = cos(theta - frameCount * 0.003) * (1000 + terrain[u][v]);
  float y = (u - cols / 2) * scl;
  float z = sin(theta - frameCount * 0.003) * (1000 + terrain[u][v]);

  return new PVector(x, y, z);
}
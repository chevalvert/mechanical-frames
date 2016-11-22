import peasy.*;
PeasyCam cam;

int cols, rows;
int scl = 10;
int w = 1000;
int h = 1000;

float flying = 0;

float[][] terrain;

void settings() {
  // fullScreen(P3D);
  size(1600, 1000, P3D);
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

PVector pos = new PVector(0, 0, 0);

void draw() {
  background(0);
  rotateX(PI/3);
  rotateZ(PI/4);
  int offset = int(frameCount * 0.3);

  flying -= 0.01;
  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = sq(noise(xoff, yoff)) * 200;
      xoff += 0.2;
    }
    yoff += 0.2;
  }


  stroke(50);
  strokeWeight(1);
  fill(0);

  float h = cols * scl / 2;
  for (int v = 0; v < rows - 1; v += 1) {
    beginShape();
    PVector
      start = toPlane(0, v),
      end = toPlane(cols - 1, v);

    vertex(start.x, start.y, -h);
    for (int u = 0; u < cols; u += 1) {
      PVector a = toPlane(u, v);
      vertex(a.x, a.y, a.z, norm(u, 0, cols), norm(v, 0, rows - 1));
    }
    vertex(end.x, end.y, -h);
    endShape(CLOSE);
  }


  stroke(255);
  strokeWeight(6);
  float r = 100;
  PVector c = toPoint(
                      int(map(mouseX, 0, width, 0, 1) * rows),
                      int(map(mouseY, 0, height, 0, 1) * cols)
                      );
  for (int v = 0; v < rows - 1; v += 1) {
    beginShape();
    for (int u = 0; u < cols; u += 1) {
      PVector a = toPlane(u, v);


      if (c.dist(new PVector(a.x, a.y)) < r) {
        vertex(a.x, a.y, a.z, norm(u, 0, cols), norm(v, 0, rows - 1));
      }
    }
    endShape();
  }




  // PVector tp = toPlane(
  //                     int(cols / 2 + sin(frameCount*0.01) * cols / 3 ),
  //                     int(rows / 2 + cos(frameCount*0.01) * rows / 3 ));

  // pos = tp.lerp(pos, 0.9);
  // strokeWeight(10);
  // stroke(255);
  // point(pos.x, pos.y, pos.z + 10);
  // strokeWeight(1);

}

PVector toPlane(int u, int v) {
  float x = u * scl - cols * scl/2;
  float y = v * scl - rows * scl/2;
  float z = terrain[u][v];

  return new PVector(x, y, z);
}

PVector toPoint(int u, int v) {
  float x = u * scl - cols * scl/2;
  float y = v * scl - rows * scl/2;
  return new PVector(x, y);
}
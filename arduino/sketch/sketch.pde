import processing.serial.*;

boolean debug = false;

Serial arduino;
ArrayList<Flipbook> flipbooks;

void settings() {
  size(400, 800, P3D);
}

void setup() {
  // printArray(Serial.list());
  arduino = new Serial(this, Serial.list()[3], 9600);

  flipbooks = new ArrayList<Flipbook>();
  flipbooks.add(new Insect('A', 0, 0, width, height / 2));
  flipbooks.add(new Sphere('B', 0, height / 2, width, height / 2));

  background(0);
}

void draw() {
  surface.setTitle(int(frameRate) + "fps");

  if (debug) {
    for (Flipbook f : flipbooks) {
      f.frameCount++;
      f.draw();
    }
  } else {
    if (arduino.available() > 0) {
      String currentSerialMessage = arduino.readStringUntil('\n');
      for (Flipbook f : flipbooks) f.update(currentSerialMessage);
    }
  }
}


void keyPressed() {
  if (key == ' ') debug = !debug;
  if (key == 'r') {
    arduino.stop();
    setup();
  }
}
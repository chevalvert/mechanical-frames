import processing.serial.*;
import codeanticode.syphon.*;

final int SIZE = 30;

Serial arduino;
SyphonServer syphon;
GameOfLife gol;

// -------------------------------------------------------------------------

void settings () {
  size(400, 800, OPENGL);
  PJOGL.profile = 1;
  noSmooth();
}

void setup () {
  hint(DISABLE_TEXTURE_MIPMAPS);
  ((PGraphicsOpenGL)g).textureSampling(3);
  // syphon = new SyphonServer(this, "flipbooks");

  try {
    arduino = new Serial(this, Serial.list()[3], 9600);
  } catch (ArrayIndexOutOfBoundsException e) {
    arduino = null;
  }

  gol = new GameOfLife(this, 400 / SIZE, 800 / SIZE);
}


void draw () {
  if (arduino != null) {
    surface.setTitle(int(frameRate) + "fps");
    if (arduino.available() > 0) {
      String currentSerialMessage = arduino.readStringUntil('\n');
      if (currentSerialMessage != null && currentSerialMessage.charAt(1) == '0') {
        char partID = currentSerialMessage.charAt(0);
        if (partID == 'A') {
          gol.iterate(0, 0, gol.cols, gol.rows / 2);

          int i = int(random(gol.cols));
          int j = int(random(gol.rows / 2));
          gol.cells[i][j] = true;
        } else if (partID == 'B') {
          gol.iterate(0, gol.rows / 2, gol.cols, gol.rows);

          int i = int(random(gol.cols));
          int j = int(random(gol.rows / 2, gol.rows));
          gol.cells[i][j] = true;
        }
      }
    }
  } else {
    surface.setTitle("(no arduino) " + int(frameRate) + "fps");
    if (mousePressed) {
      int i = mouseX / SIZE;
      int j = mouseY / SIZE;
      gol.cells[i][j] = true;
    }
  }

  image(gol.render(width, height), 0, 0);
  // syphon.sendImage(gol.render(width, height));
}

void keyPressed() {
  switch (key) {
    case 'r' :
      if (arduino != null) arduino.stop();
      if (syphon != null) syphon.dispose();
      setup();
      break;

    case 'a' : {
      if (arduino == null) {
        gol.iterate(0, 0, gol.cols, gol.rows / 2);

        if (gol.diffHistory(0, 0, gol.cols, gol.rows / 2) < 4) {
          int i = int(random(gol.cols));
          int j = int(random(gol.rows / 2));
          gol.spawn(gol.STAR, i, j);
        }
      }
      break;
    }

    case 'z' : {
      if (arduino == null) {
        gol.iterate(0, gol.rows / 2, gol.cols, gol.rows);

        if (gol.diffHistory(0, gol.rows / 2, gol.cols, gol.rows) < 4) {
          int i = int(random(gol.cols));
          int j = int(random(gol.rows / 2, gol.rows));
          gol.spawn(gol.STAR, i, j);
        }
      }
      break;
    }
  }
}
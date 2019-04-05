public class Top extends Flipbook {

  Top(PApplet parent, char id, int x, int y) { 
    super(parent, id, x, y, parent.width, parent.height / 2);
  }
  Top(PApplet parent, char id, int x, int y, int w, int h) { 
    super(parent, id, x, y, w, h);
  }

  // -------------------------------------------------------------------------

  int largeur = 50;
  int hauteur = 50;

  void setup() {
    // size(800, 600);
    textSize(80);
    textAlign(CENTER, CENTER);
  }


  void draw() {
    /*
    float x = random(super.width);
    float y = random(super.height);
     
    super.background(0);
     
    stroke(255);
    fill(255, 255, 0);
    */
     
    super.background(super.frameCount % 255);

    fill(255);

    // ellipse(x, y, largeur, hauteur);
    text(super.frameCount, super.width / 2, super.y + super.height / 2);
  }
}
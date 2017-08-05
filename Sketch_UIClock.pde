Clock c;
void setup() {
  fullScreen();
  c = new Clock(width/2, height/2, min(width, height) * 0.95 * 0.5);
  c.type = 2;
}

void draw() {
  background(0, 0, 0);
  
  c.drawClock();
}

void keyPressed() {
  if (keyCode == UP) {
    c.level ++;
  } else if (keyCode == DOWN) {
    c.level --;
  } else if (keyCode == LEFT) {
    c.type -= 1;
  } else if (keyCode == RIGHT) {
    c.type += 1;
  }
  println(c.level);
}

void mousePressed() {
  c.dial.radius += 10;
}
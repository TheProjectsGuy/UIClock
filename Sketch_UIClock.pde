Clock c;
void setup() {
  fullScreen();
  c = new Clock(width/2, height/2, min(width, height) * 0.95 * 0.5);
  c.type = 2;
}

void draw() {
  background(0, 0, 0);
  setUserChoiceConfigurations();
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
  println(c.level + " in " + c.type);
}

void setUserChoiceConfigurations() {
  c.color_text = color(255);
  c.color_hour = color(0, 0, 255);
  c.color_minute = color(0, 255, 0);
  c.color_second = color(255, 0, 0);
}
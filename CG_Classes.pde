/*
This file contains classes essential for Core Graphics operations.
 *Point
 *Line
 *Circle
 */

//Core Graphics Point
class CGPoint {
  float x;
  float y;
  CGPoint() {
  }
  CGPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void plot(color c) {
    stroke(c);
    strokeWeight(2);
    ellipse(x, y, 2, 2);
  }
  void plot() {
    plot(color(255));
  }
}

//Core Graphics Line
class CGLine {
  CGPoint start, end;
  CGLine() {
  }
  CGLine(CGPoint start, CGPoint end) {
    this.start = start;
    this.end = end;
  }
  CGLine(CGPoint start, float length_Line, float angle) {  //Note that angle is taken clockwise w.r.t. vertical axis
    this.start = start;
    this.end = new CGPoint(start.x + length_Line * sin(angle), start.y - length_Line * cos(angle));
  }
  float stroke_weight = 1;
  color strokeColor = color(255);

  void drawLine() {
    stroke(strokeColor);
    strokeWeight(stroke_weight);
    line(start.x, start.y, end.x, end.y);
  }
  void changeEnd(float newLength, float newAngle) {
    this.end = new CGPoint(start.x + newLength * sin(newAngle), start.y - newLength * cos(newAngle));
  }
  void changeEnd(CGPoint newEndingPoint) {
    this.end = newEndingPoint;
  }
}

//Code Graphics Arc
class CGArc {
  CGPoint center = new CGPoint();
  float arcWidth, start_angle, end_angle;  //NOTE : Angle is taken w.r.t. vertical axis (clockwise). 
  float radius;
  float stroke_weight = 20;
  boolean fill = false;
  color fill_color = color(0);
  color strokeColor = color(255);
  CGArc() {
  }
  CGArc(CGPoint center, float diameter, float start_angle, float end_angle) {
    this.center = center;
    this.arcWidth = diameter;
    this.radius = arcWidth/2.0;
    this.start_angle = start_angle;
    this.end_angle = end_angle;
  }

  void drawArc() {
    if (!fill)
      noFill();
    else 
    fill(fill_color);
    strokeWeight(stroke_weight);
    stroke(strokeColor);
    arc(center.x, center.y, arcWidth, arcWidth, map(start_angle, 0, 2*PI, -90 * PI/180, 270*PI/180), map(end_angle, 0, 2*PI, -90 * PI/180, 270*PI/180));
  }
}

//Core Graphics Circle
class CGCircle {
  CGPoint center = new CGPoint();
  float radius;
  CGCircle() {
  }
  CGCircle(float centerX, float centerY, float radius) {
    center.x = centerX;
    center.y = centerY;
    this.radius = radius;
  }
  CGCircle(CGPoint center, float radius) {
    this.center = center;
    this.radius = radius;
  }
  CGCircle(CGCircle c) {
    this.center = c.center;
    this.radius = c.radius;
  }
  float stroke_weight = 2;
  color strokeColor = color(255);
  color backgroundColor = color(0);
  void drawCircle() {
    strokeWeight(stroke_weight);
    stroke(strokeColor);
    if (backgroundColor != -1)
      fill(backgroundColor);
    else 
    noFill();
    ellipse(center.x, center.y, 2*radius, 2*radius);
  }
}
void setup() {
  size(100,100);
  Time time1 = new Time(3,45,1),time2 = new Time(1,1,2);
  Time t = time1.difference_Time(time2);
  println(t.description());
}

void draw() {
}
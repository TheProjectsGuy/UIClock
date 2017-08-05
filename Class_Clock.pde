//This class keeps regulation of Time type objects
static class Time {
  int hours, minutes, seconds;
  Time() {
    hours = minutes = seconds = 0;
  }
  Time(int hr, int min, int sec) {
    seconds = sec;
    minutes = min + seconds / 60;
    seconds %= 60;
    hours = hr + minutes / 60;
    minutes %= 60;
  }
  void updateTime() {
    hours = hour();
    minutes = minute();
    seconds = second();
  }
  String description() {
    return str(hours) + " : " + str(minutes) + " : " + str(seconds);
  }
  static float timeInSeconds(Time time1) {
    return time1.hours * 60.0 * 60.0 + time1.minutes * 60.0 + time1.seconds;
  }
  float timeInSeconds() {
    return timeInSeconds(this);
  }  
  static Time addTimes(Time time1, Time time2) {
    Time result = new Time();
    result.seconds = time1.seconds + time2.seconds;
    result.minutes = result.seconds / 60 + time1.minutes + time2.minutes;
    result.seconds %= 60;
    result.hours = time1.minutes / 60 + time1.hours + time2.hours;
    result.minutes %= 60;
    return result;
  }
  Time addTime(Time t) {
    return addTimes(this, t);
  }
  static Time difference_Time(Time time1, Time time2) {
    if (timeInSeconds(time1) < timeInSeconds(time2)) {
      return difference_Time(time2, time1);
    }
    //Now, time1 > time2 always
    Time result = new Time();
    result.seconds = time1.seconds - time2.seconds + 60;
    result.minutes = time1.minutes - time2.minutes + 60 + result.seconds / 60 - 1;
    result.seconds %= 60;
    result.hours = time1.hours - time2.hours - 1 + result.minutes / 60;
    result.minutes %= 60;
    return result;
  }
  Time difference_Time(Time withTime) {
    return difference_Time(this, withTime);
  }
}

//This class deals with everything associated with a clock
class Clock {
  Time timeOnClock;
  CGCircle dial = new CGCircle();
  Clock(float centerX, float centerY, float radius) {  //Constructor
    timeOnClock = new Time(hour(), minute(), second());
    dial.center.x = centerX;
    dial.center.y = centerY;
    dial.radius = radius;
    dial.stroke_weight = 5;
  }
  Clock(CGPoint center, float radius) {  //Constructor
    dial.center = center;
    timeOnClock = new Time(hour(), minute(), second());
    dial.radius = radius;
    dial.stroke_weight = 5;
  }
  color color_second = color(255, 0, 0), color_minute = color(0, 255, 0), color_hour = color(0, 0, 255);
  color color_text = color(255);
  int type = 1;
  /*
   *1 - Analog clock
   *2 - Analog Arc clock (Under planning phase)
   */

  int level = 1;  //This decides the features
  /*
  Type : Analog
   *1 for just the dial, hour and minute
   *2 is to include a seconds hand
   *3 is to include 4 divisions on the dial (to show numbers 12, 3, 6 and 9)
   *4 is to include all the divisions on the hour dial (12 divisions) [Design included]
   *5 is to include all the 60 divisions on the dial (0-60)
   Type : Analog Arc
   *1 for just the basic arcs
   *2 to show numbers just after arcs (trailing numbers)
   */
  void drawClock() {
    timeOnClock.updateTime();
    switch (type) {
    case 1:
      drawClock_Analog();
      break;
    case 2:
      drawClock_Analog_Arc();
      break;
    default:
      println("ILLEGAL Type of CLOCK");
    }
  }

  //Analog Arc segment : An analog type clock blended into arcs
  void drawClock_Analog_Arc() {
    level = constrain(level, 0, 2);  //constrain the level in the bounds
    CGCircle dialBackground = new CGCircle(dial);
    dialBackground.stroke_weight = 1;
    dialBackground.backgroundColor = dial.backgroundColor;
    dialBackground.drawCircle();  //To make the dial without losing data, so we make the background of the dial first and then put the frame
    float stroke_weights = dial.radius / 7.0 * 1.75;  //Stroke weight of the arcs 
    //Create the arcs
    CGArc seconds_Arc = new CGArc(dial.center, dial.radius * 0.85 * 2, 0, map(second(), 0, 60, 0, 2*PI));
    seconds_Arc.stroke_weight = stroke_weights;
    CGArc minutes_Arc = new CGArc(dial.center, dial.radius * 0.85 * 2 * 2.0/3.0, 0, map(minute() + (second() / 60.0), 0, 60, 0, 2*PI));
    minutes_Arc.stroke_weight = stroke_weights;
    CGArc hours_Arc = new CGArc(dial.center, dial.radius * 0.85 * 2 * 1/3.0, 0, map((hour() % 12) + (minute()/60) + second()/(60*60), 0, 12, 0, 2*PI));
    hours_Arc.stroke_weight = stroke_weights;
    analog_Arc_makeArcs(seconds_Arc, minutes_Arc, hours_Arc);  //Make the arcs
    dial.backgroundColor = dialBackground.backgroundColor;

    textSize(stroke_weights * 0.55);
    fill(color_text);
    textAlign(CENTER,CENTER);
    text(str(timeOnClock.seconds), dial.center.x + seconds_Arc.radius * sin(seconds_Arc.end_angle), dial.center.y - seconds_Arc.radius * cos(seconds_Arc.end_angle));
    text(str(timeOnClock.minutes), dial.center.x + minutes_Arc.radius * sin(minutes_Arc.end_angle), dial.center.y - minutes_Arc.radius * cos(minutes_Arc.end_angle));
    text(str(timeOnClock.hours % 12), dial.center.x + hours_Arc.radius * sin(hours_Arc.end_angle), dial.center.y - hours_Arc.radius * cos(hours_Arc.end_angle));
  }

  void analog_Arc_makeArcs(CGArc seconds_Arc, CGArc minutes_Arc, CGArc hours_Arc) {  //To make the arcs on the screen based on level
    if (level >= 2) {
      //Make white arcs
      CGArc c = new CGArc();
      c = seconds_Arc;
      c.strokeColor = color(255);
      c.drawArc();
      c = minutes_Arc;
      c.strokeColor = color(255);
      c.drawArc();
      c = hours_Arc;
      c.strokeColor = color(255);
      c.drawArc();
      color_second = color(red(color_second), green(color_second), blue(color_second), 127);
      color_minute = color(red(color_minute), green(color_minute), blue(color_minute), 127);
      color_hour = color(red(color_hour), green(color_hour), blue(color_hour), 127);
    }
    if (level >= 1) {
      if (level == 1) {
        color_second = color(red(color_second), green(color_second), blue(color_second), 255);
        color_minute = color(red(color_minute), green(color_minute), blue(color_minute), 255);
        color_hour = color(red(color_hour), green(color_hour), blue(color_hour), 255);
      }
      seconds_Arc.strokeColor = color_second;
      minutes_Arc.strokeColor = color_minute;
      hours_Arc.strokeColor = color_hour;
      seconds_Arc.drawArc();
      minutes_Arc.drawArc();
      hours_Arc.drawArc();
    }
    dial.backgroundColor = -1;
    dial.drawCircle();  //Make the dial anyways
  }

  //Analog segment : Traditional analog clock
  void drawClock_Analog() {
    level = constrain(level, 0, 5);
    if (level >= 1)  //Make the clock if and only if the clock level is on
      makeClock();
  }
  void makeClock() {
    CGCircle dialBackground = new CGCircle(dial);
    dialBackground.stroke_weight = 0;
    dialBackground.backgroundColor = dial.backgroundColor;
    dialBackground.drawCircle();
    if (level >= 3) {
      makeDivisionsOnDial();
    }  //Make divisions on the dial
    dial.backgroundColor = -1;  //Just to fit the dial over background (if fill is on, it'll clear the divisions)
    dial.drawCircle();  //Make the dial
    dial.backgroundColor = dialBackground.backgroundColor;
    makeHands();  //Make hands of the clock
  }
  void makeDivisionsOnDial() {  //This function is to make the clock divisions
    for (int i = 1; i <= 60; i++) {
      float angle = map(i, 0, 60, 0, 2*PI);
      CGLine l = new CGLine(new CGPoint(dial.center.x + dial.radius * sin(angle), dial.center.y - dial.radius * cos(angle)), -dial.radius * 0.05, angle);
      float _stroke_weight = 0;
      color _stroke_color = dial.backgroundColor;
      fill(color_text);
      textAlign(CENTER, CENTER);
      if (i % 15 == 0 && level >= 3) {  //The 12,3,6 and 9 of hour hand
        _stroke_weight = 4; 
        _stroke_color = color(#B8E1F0);
        l.changeEnd(-dial.radius * 0.20, angle);
        textSize(dial.radius/12);
        text(str(i/5), l.end.x, l.end.y);
        l.changeEnd(-dial.radius * 0.1, angle);
      } else if (i%5 == 0 && level >= 4) {  //The numbers on the hour
        _stroke_weight = 2; 
        _stroke_color = color(127);
        l.changeEnd(-dial.radius * 0.15, angle);
        textSize(dial.radius/20);
        text(str(i/5), l.end.x, l.end.y);
        l.changeEnd(-dial.radius * 0.075, angle);
      } else if (level >= 5) {  //All 60 divisions
        _stroke_weight = 1; 
        _stroke_color = color(64);
      }
      l.stroke_weight = _stroke_weight;
      l.strokeColor = _stroke_color;
      l.drawLine();
      l.changeEnd(-dial.radius * 0.15, angle);
    }
  }
  void makeHands() {
    CGLine hours_hand = new CGLine(), minutes_hand = new CGLine(), seconds_hand = new CGLine();
    float angle_seconds = map(timeOnClock.seconds, 0, 60, 0, 2*PI);  //Make a revolution in 60 seconds
    float angle_minutes = map(timeOnClock.minutes, 0, 60, 0, 2*PI) + map(timeOnClock.seconds, 0, 60, 0, 2*PI / 60);  //60 seconds make it tick by one division (360/60 = 6 degrees)
    float angle_hours = map(timeOnClock.hours, 0, 12, 0, 2*PI) + map(timeOnClock.minutes, 0, 60, 0, 30 * PI/180) + map(timeOnClock.seconds, 0, 60, 0, 0.5 * PI/180);  //60 min give 30 degrees and 60 seconds give 1/2 degrees
    if (level >= 1) {
      //sample code
      hours_hand = new CGLine(dial.center, dial.radius * 0.55, angle_hours);
      minutes_hand = new CGLine(dial.center, dial.radius * 0.8, angle_minutes);
      //characteristics of hands
      hours_hand.strokeColor = color_hour;
      minutes_hand.strokeColor = color_minute;
      hours_hand.stroke_weight = 5;
      minutes_hand.stroke_weight = 3;
      hours_hand.drawLine();
      minutes_hand.drawLine();
    }
    if (level >= 2) {
      seconds_hand = new CGLine(dial.center, dial.radius * 0.9, angle_seconds);
      seconds_hand.strokeColor = color_second;
      seconds_hand.stroke_weight = 1;
      seconds_hand.drawLine();
    }
  }
}
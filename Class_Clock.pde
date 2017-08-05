static class Time {
  int hours, minutes, seconds;
  Time() {
    hours = minutes = seconds = 0;
  }
  Time(int hr,int min,int sec) {
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
  static Time addTimes(Time time1,Time time2) {
    Time result = new Time();
    result.seconds = time1.seconds + time2.seconds;
    result.minutes = result.seconds / 60 + time1.minutes + time2.minutes;
    result.seconds %= 60;
    result.hours = time1.minutes / 60 + time1.hours + time2.hours;
    result.minutes %= 60;
    return result;
  }
  Time addTime(Time t) {
    return addTimes(this,t);
  }
  static Time difference_Time(Time time1, Time time2) {
    if (timeInSeconds(time1) < timeInSeconds(time2)) {
      return difference_Time(time2,time1);
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
    return difference_Time(this,withTime);
  }
}

class Clock {
  Time timeOnClock;
}
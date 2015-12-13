class Timer {
  float t = 0.0, dt = 0.01;
  int index;

  Timer() {
    t = 0.0;
  }

  void update() {
    if (timerRunning && t < 9.99) {
      t = round((t + dt) * 100)/100.0;    
      index = round(t * 100);    
    }
    else {
      t = 0.0;
      timerRunning = false;
    }
  }
}


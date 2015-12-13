class PendulumView {
  float X, Y, W, H;

  boolean isclicked = false;
  boolean isdragged = false;

  float theta = 0.0;
  
  PendulumView(float X, float Y) {
    this.X = X;
    this.Y = Y;
  }

  void draw() {
    pushMatrix();

    translate(X, Y);
    if (angleGraphHover)
      rotate(-angleGraphTheta);
    else if (timerRunning)
      rotate(-simulation.data[timer.index]);    
    else
      rotate(-simulation.theta0);

    // origin point
    noFill();  
    stroke(#6C6C6C); 
    strokeWeight(6);
    point(0, 0);

    // thread and bob
    strokeWeight(2);
    if (isclicked) 
      fill(#E5E5E5);
    else 
      noFill();
    ellipse(0, simulation.l * scale, 30 + simulation.m * 7, 30 + simulation.m * 7); 
    line(0, 0, 0, simulation.l * scale);

    popMatrix();
  }

  void clicked() {
    if (mouseX > X - 100 && mouseX < X + 100 && mouseY > Y && mouseY < Y + 150) {
      timerRunning = false;
      isclicked = true;
    }
  }

  void dragged() {
    if (isclicked) {
      PVector previous = new PVector(pmouseX - X, pmouseY - Y);
      PVector current = new PVector(mouseX - X, mouseY - Y);
      float dtheta = atan2(previous.y, previous.x) - atan2(current.y, current.x);
      if (abs(simulation.theta0 + dtheta) < PI/4) {
        float theta0 = simulation.theta0 + dtheta;
        simulation.update(theta0);
        theta = theta0;
      }
      isdragged = true;      
    }
  }

  void released() {
    isclicked = false;
    isdragged = false;
  }
}


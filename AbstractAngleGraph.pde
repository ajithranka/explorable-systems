class AbstractAngleGraph {
  float X, Y, W, H;
  PendulumSimulation shadowSimulation;
  
  AbstractAngleGraph(float X, float Y, float W, float H) {
    this.X = X;
    this.Y = Y;
    this.W = W;
    this.H = H;
  
    shadowSimulation = new PendulumSimulation(0);
  }

  void draw() {
    pushMatrix();

    translate(X, Y);

    // x and y axis
    fill(#6C6C6C);  
    stroke(#6C6C6C); 
    strokeWeight(2);
    line(0, H/2, W, H/2);
    line(0, 0, 0, H);

    // x axis ticks
    textSize(12);
    for (int i = 1; i <= 10; i++) {
      float imapped = map(i, 0, 10, 0, W);
      line(imapped, H/2, imapped, H/2 + 4);
      text(i, imapped - 3, H/2 + 16);
    }

    // y axis ticks
    textSize(12);
    for (float i = -PI/4; i <= PI/4; i = i + PI/12) {
      float imapped = map(i, -PI/4, PI/4, H, 0);
      line(0, imapped, -4, imapped);
      text(nfp(degrees(i), 1, 0), -30, imapped + 5);
    }

    // axis labels
    textSize(14);
    text("time (s)", W - 40, H/2 - 10);
    text("angle", 10, -10);

    // all possible curves
    for (float i = 0; i <= PI/4; i = i + PI/24) {
      drawCurve(i, #2AA198, 180);
    }
   
    // current curve
    float currentTheta = simulation.theta0;
    drawCurve(currentTheta, #CB4B16, 255);

    // on hover and mouse pressed
    if (mouseX > X && mouseX < X + W && mouseY > Y && mouseY < Y + H/2 && mousePressed) {
      timerRunning = false;
      
      float y = mouseY - Y;
      float ymapped = map(y, 0, H/2, PI/4, 0);
      for (int i = 0; i < 7; i++) {
        if (abs(ymapped - i * PI/24) < PI/48) {
          float theta = i * PI/24;
          
          stroke(#CB4B16);
          strokeWeight(1);
          float yline = map(i * PI/24, 0, PI/4, H/2, 0);
          line(0, yline, W, yline);

          simulation.update(theta);
        }
      }
    }
    
    popMatrix();
  }

  void drawCurve(float theta, color graphColor, int opacity) {
    shadowSimulation.update(theta);
    
    noFill();
    strokeWeight(2);
    stroke(graphColor, opacity);
    beginShape();    
    for (int j = 0; j < 1000; j++) {
      float t = j * 0.01;
      float tmapped = map(t, 0, 10, 0, W);
      float ymapped = map(shadowSimulation.data[j], -PI/4, PI/4, H, 0);
      vertex(tmapped, ymapped);
    }
    endShape();
  }
}


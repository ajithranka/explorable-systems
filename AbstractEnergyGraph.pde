class AbstractEnergyGraph {
  float X, Y, W, H;

  AbstractEnergyGraph(float X, float Y, float W, float H) {
    this.X = X;
    this.Y = Y;
    this.W = W;
    this.H = H;
  }

  void draw() {
    pushMatrix();

    translate(X, Y);

    // x and y axis
    noFill();  
    stroke(#6C6C6C); 
    strokeWeight(2);
    line(0, H/2, W, H/2);
    line(W/2, 0, W/2, H);

    // x axis ticks
    textSize(12);
    for (float i = -PI/4; i <= PI/4; i = i + PI/12) {
      float imapped = map(i, -PI/4, PI/4, 0, W);
      line(imapped, H/2, imapped, H/2 + 4);
      if (i != 0) text(nfp(degrees(i), 1, 0), imapped - 13, H/2 + 16);
    }

    // y axis ticks
    textSize(12);
    float maxEnergy = 1 - cos(PI/4);
    float stepLength = maxEnergy/3;
    for (float i = -maxEnergy; i <= maxEnergy; i = i + stepLength) {
      float imapped = map(i, -maxEnergy, maxEnergy, H, 0);
      line(W/2, imapped, W/2 - 4, imapped);
      if (!(abs(i) < 0.01)) text(nfp(i, 1, 3), W/2 - 45, imapped + 5);
    }

    // axis labels
    textSize(14);
    text("initial angle", W - 40, H/2 - 10);
    text("total energy", W/2, -10);

    // data points
    noFill();
    strokeWeight(2);
    stroke(#2AA198);
    beginShape();
    for (float i = -PI/4; i <= PI/4; i = i + PI/(2400)) {
      float energy = simulation.l - simulation.l * cos(i);
      float energymapped = map(energy, -maxEnergy, maxEnergy, H, 0);
      float imapped = map(i, -PI/4, PI/4, 0, W);
      vertex(imapped, energymapped);
    }
    endShape();

    // on hover and mouse pressed
    if (mouseX > X && mouseX < X + W && mouseY > Y && mouseY < Y + H/2 && mousePressed) {
      timerRunning = false;
      
      float x = mouseX - X;
      float xmapped = map(x, 0, W, -PI/4, PI/4);
      simulation.update(xmapped);    
      
      highlightPoint(xmapped);  // lag between frame updates
      
      stroke(#2AA198);
      strokeWeight(1);
      line(x, 0, x, H/2);
    } else {
      // highlight current point
      float currentTheta = simulation.theta0;
      highlightPoint(currentTheta);
    }

    popMatrix();
  }

  void highlightPoint(float theta) {
    float maxEnergy = 1 - cos(PI/4);

    float thetamapped = map(theta, -PI/4, PI/4, 0, W);
    float energy = simulation.l - simulation.l * cos(theta);
    float energymapped = map(energy, -maxEnergy, maxEnergy, H, 0);

    stroke(#CB4B16);
    strokeWeight(8);
    point(thetamapped, energymapped);
  }
}


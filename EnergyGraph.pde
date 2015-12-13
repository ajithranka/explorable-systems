class EnergyGraph {
  float X, Y, W, H;
  float total, potential, kinetic;
  
  EnergyGraph(float X, float Y, float W, float H) {
    this.X = X;
    this.Y = Y;
    this.W = W;
    this.H = H;
  }

  void draw() {
    pushMatrix();

    translate(X, Y);
    
    // baseline
    noFill();  
    stroke(#6C6C6C); 
    strokeWeight(2);
    line(20, H, W - 20, H);

    if (angleGraphHover) {
      total = calculatePotential(simulation.theta0);
      potential = calculatePotential(angleGraphTheta);
      kinetic = total - potential;
    }
    else if (timerRunning) {
      total = calculatePotential(simulation.theta0);
      potential = calculatePotential(simulation.data[timer.index]);
      kinetic = total - potential;
    }
    else {
      total = calculatePotential(simulation.theta0);
      potential = calculatePotential(simulation.theta0);
      kinetic = calculateKinetic(simulation.theta0);
    }

    float maxEnergy = calculatePotential(PI/4);
    float potentialMapped = map(potential, 0, maxEnergy, H, 0);
    float kineticMapped = map(kinetic, 0, maxEnergy, H, 0);
    float totalMapped = map(total, 0, maxEnergy, H, 0);
    
    noStroke();
    fill(#CB4B16);
    rect(W/3 - 15, potentialMapped, 30, H - potentialMapped);
    rect(2*W/3 - 15, kineticMapped, 30, H - kineticMapped);
    
    stroke(#6C6C6C);
    strokeWeight(2);
    line(20, totalMapped, W - 20, totalMapped);
    
    fill(#6C6C6C);
    textSize(14);
    text("U", W/3 - 5, H + 20);
    text("K", 2*W/3 - 5, H + 20);
    text("T", W - 10, totalMapped + 5);
    
    popMatrix();
  }
  
  float calculatePotential(float theta) {
    float h = simulation.l - simulation.l * cos(theta);
    return simulation.m * g * h;
  }
  
  float calculateKinetic(float theta) {
    float l = simulation.l, m = simulation.m, theta0 = simulation.theta0;
    float velocity = - sqrt(g/l) * sqrt(sq(theta0) - sq(theta));
    return 1/2.0 * m * sq(velocity);
  } 
}


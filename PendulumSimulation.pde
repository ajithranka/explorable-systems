class PendulumSimulation {
  float m = 1.0, l = 1.0;
  float theta0;
  float[] data = new float[1000];
  
  PendulumSimulation(float theta0) {
    update(theta0);
  }
  
  void update(float theta0) {
    this.theta0 = theta0;

    float t = 0.0, dt = 0.01;
    for(int i = 0; i < 1000; i++) {
      t = t + dt;
      data[i] = theta0 * cos(sqrt(g/l) * t);
    }
  }
} 

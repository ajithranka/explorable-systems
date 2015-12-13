class AngleGraph {
  float X, Y, W, H;

  AngleGraph(float X, float Y, float W, float H) {
    this.X = X;
    this.Y = Y;
    this.W = W;
    this.H = H;
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
    
    // data points
    noFill();
    strokeWeight(2);
    stroke(#2AA198);
    beginShape();    
    for (int i = 0; i < 1000; i++) {
      float t = i * 0.01;
      float tmapped = map(t, 0, 10, 0, W);
      float ymapped = map(simulation.data[i], -PI/4, PI/4, H, 0);
      vertex(tmapped, ymapped);
    }
    endShape();

    if (mouseX > X && mouseX < X + W && mouseY > Y && mouseY < Y + H && mousePressed) {
      float t = mouseX - X;
      int index = round(map(t, 0, W, 0, 1000));
      float y = simulation.data[index];
      float ymapped = map(y, -PI/4, PI/4, H, 0);

      stroke(#2AA198);
      strokeWeight(1);
      line(t, 0, t, H);

      stroke(#CB4B16);
      strokeWeight(8);
      point(t, ymapped);

      angleGraphHover = true;
      angleGraphTheta = y;
      timerRunning = false;
    }
    else if (timerRunning) {
      float y = simulation.data[timer.index];
      float ymapped = map(y, -PI/4, PI/4, H, 0);
      float t = timer.t;
      float tmapped = map(t, 0, 10, 0, W);

      stroke(#CB4B16);
      strokeWeight(8);
      point(tmapped, ymapped);
    } 
    else {
      float start = map(simulation.data[0], -PI/4, PI/4, H, 0);
      stroke(#CB4B16);
      strokeWeight(8);
      point(0, start);

      angleGraphHover = false;
    }

    popMatrix();
  }
}


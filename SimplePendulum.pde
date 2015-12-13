final float scale = 120;
final float g = 9.80665;

PendulumSimulation simulation;
PendulumView pendulum;
AngleGraph angleGraph;
EnergyGraph energyGraph;
AbstractAngleGraph abstractAngleGraph;
AbstractEnergyGraph abstractEnergyGraph;

Timer timer;

boolean angleGraphHover;
float angleGraphTheta;
boolean timerRunning;
boolean levelUp;

PFont font;
PImage arrow;

void setup() {
  size(1024, 640);

  simulation = new PendulumSimulation(PI/8);
  pendulum = new PendulumView(180, 235);
  angleGraph = new AngleGraph(340, 225, 340, 150);
  energyGraph = new EnergyGraph(740, 225, 140, 150);
  abstractAngleGraph = new AbstractAngleGraph(340, 70, 340, 150);
  abstractEnergyGraph = new AbstractEnergyGraph(740, 70, 200, 150);
  
  timer = new Timer();
  
  angleGraphHover = false;
  timerRunning = false;
  
  font = createFont("Sans Serif", 20);
  textFont(font);

  arrow = loadImage("arrow.png");
  
  smooth();
}

void draw() {
  background(255);
  
  pendulum.draw(); 
  angleGraph.draw();
  energyGraph.draw();

  timer.update();

  if(levelUp) {
    image(arrow, 460, 250);
    abstractAngleGraph.draw();
    abstractEnergyGraph.draw(); 
  }

  textSize(14);
  fill(#2AA198);
  text("SPACE to play.", 30, 20);
  text("UP/DOWN for more.", 30, 40); 
}

void keyPressed() {
  if(key == ' ')
    timerRunning = !timerRunning;
  if(keyCode == UP && !levelUp) {
    levelUp = true;
    pendulum.Y = pendulum.Y + 150;
    angleGraph.Y = angleGraph.Y + 150;
    energyGraph.Y = energyGraph.Y + 150;    
  }
  if(keyCode == DOWN && levelUp) {
    levelUp = false;
    pendulum.Y = pendulum.Y - 150;
    angleGraph.Y = angleGraph.Y - 150;
    energyGraph.Y = energyGraph.Y - 150;
  }
}

void mousePressed() {
  pendulum.clicked();
}

void mouseDragged() {
  pendulum.dragged();
} 

void mouseReleased() {
  pendulum.released();
}

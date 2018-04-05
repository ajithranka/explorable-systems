const g = 9.80665

let canvas, arrow
let simulation, pendulum, angleGraph, energyGraph, timer
let lSlider, mSlider, theta0Slider

const state = {
  timerRunning: false,
  angleGraphHover: false,
  angleGraphTheta: 0
}

function preload() {
  arrow = loadImage("arrow.png")
}

function setup() {
  canvas = createCanvas(1024, 640)

  mSlider = createSlider(1, 2, 2, 0.25)
  mSlider.position(20, 20)
  mSlider.changed(massChanged)

  lSlider = createSlider(1, 2, 2, 0.25)
  lSlider.position(20, 40)
  lSlider.changed(lengthChanged)

  theta0Slider = createSlider(-PI/4, PI/4, PI/4, PI/12)
  theta0Slider.position(20, 60)
  theta0Slider.changed(theta0Changed)

  simulation = new PendulumSimulation(theta0Slider.value())
  pendulum = new PendulumView(180, 235)
  angleGraph = new AngleGraph(340, 225, 340, 150)
  energyGraph = new EnergyGraph(740, 225, 140, 150)

  timer = new Timer()

  textFont("Avenir Next")
}

function draw() {
  background(250)

  pendulum.draw()
  angleGraph.draw()
  energyGraph.draw()

  timer.update()

  textSize(12)
  fill("#6C6C6C")
  stroke("#6C6C6C")
  strokeWeight(1)
  text("m = " + mSlider.value() + " kg", 160, 32)
  text("l = " + lSlider.value() + " m", 160, 52)
  text("θ = " + nfp(round(degrees(theta0Slider.value())), 1, 0) + " deg", 160, 72)
}

function keyPressed() {
  if(key == ' ')
    state.timerRunning = !state.timerRunning
}

function mousePressed() {
  pendulum.pressed()
}

function mouseDragged() {
  pendulum.dragged()
}

function mouseReleased() {
  pendulum.released()
}

function massChanged() {
  const newMass = mSlider.value()
  simulation.updateMass(newMass)
}

function lengthChanged() {
  const newLength = lSlider.value()
  simulation.updateLength(newLength)
}

function theta0Changed() {
  const newTheta0 = theta0Slider.value()
  simulation.updateTheta0(newTheta0)
}

class Timer {
  constructor() {
    this.t     = 0.0
    this.dt    = 0.01
    this.index = 0
  }

  update() {
    if (state.timerRunning && this.t < 9.99) {
      this.t = round((this.t + this.dt) * 100)/100.0
      this.index = round(this.t * 100)
    }
    else {
      this.t = 0.0
      this.index = 0
      state.timerRunning = false
    }
  }
}

class PendulumSimulation {
  constructor(theta0) {
    this.m = mSlider.value()
    this.l = lSlider.value()
    this.theta0 = theta0Slider.value()
    this.data = Array(1000)

    this.computeData()
  }

  computeData() {
    let t = 0.0, dt = 0.01
    for(let i = 0; i < 1000; i++) {
      t = t + dt;
      this.data[i] = this.theta0 * cos(sqrt(g/this.l) * t);
    }
  }

  updateMass(m) {
    this.m = m
    this.computeData()
  }

  updateLength(l) {
    this.l = l
    this.computeData()
  }

  updateTheta0(theta0) {
    this.theta0 = theta0
    this.computeData()
  }
}

class PendulumView {
  constructor(x, y) {
    this.x = x
    this.y = y
    this.theta = 0

    this.isClicked = false
    this.isDragged = false
  }

  draw() {
    push();

    translate(this.x, this.y)
    if (state.angleGraphHover)
      rotate(-state.angleGraphTheta)
    else if (state.timerRunning)
      rotate(-simulation.data[timer.index])
    else
      rotate(-simulation.theta0)

    // origin point
    noFill()
    stroke("#6C6C6C")
    strokeWeight(6)
    point(0, 0)

    // thread and bob
    strokeWeight(2)
    if (this.isClicked)
      fill("#E5E5E5")
    else
      noFill()
    ellipse(0, simulation.l * 60, 30 + simulation.m * 10)
    line(0, 0, 0, simulation.l * 60)

    pop()
  }

  pressed() {
    if (mouseX > this.x - 100 && mouseX < this.x + 100 && mouseY > this.y && mouseY < this.y + 150) {
      state.timerRunning = false
      this.isClicked = true
    }
  }

  dragged() {
    if (this.isClicked) {
      const previous = createVector(pmouseX - this.x, pmouseY - this.y)
      const current = createVector(mouseX - this.x, mouseY - this.y)
      const dtheta = atan2(previous.y, previous.x) - atan2(current.y, current.x)
      if (abs(simulation.theta0 + dtheta) < PI/4) {
        const theta0 = simulation.theta0 + dtheta
        simulation.updateTheta0(theta0)
        this.theta = theta0
      }
      this.isDragged = true
    }
  }

  released() {
    this.isClicked = false;
    this.isDragged = false;
  }
}

class AngleGraph {
  constructor(x, y, w, h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  draw() {
    push()

    translate(this.x, this.y)

    // x and y axis
    fill("#6C6C6C")
    stroke("#6C6C6C")
    strokeWeight(2)
    line(0, this.h/2, this.w, this.h/2)
    line(0, 0, 0, this.h)

    // x axis ticks (time)
    textSize(12)
    for (let t = 1; t <= 10; t++) {
      const tMapped = map(t, 0, 10, 0, this.w)
      strokeWeight(2)
      line(tMapped, this.h/2, tMapped, this.h/2 + 4)
      strokeWeight(1)
      text(t, tMapped - 3, this.h/2 + 16)
    }

    // y axis ticks (angle)
    for (let angle = -PI/4; angle <= PI/4; angle += PI/12) {
      const angleMapped = map(angle, -PI/4, PI/4, this.h, 0)
      strokeWeight(2)
      line(0, angleMapped, -4, angleMapped)
      strokeWeight(1)
      text(nfp(round(degrees(angle)), 1, 0), -30, angleMapped + 5)
    }

    // axis labels
    textSize(14)
    text("time (s)", this.w - 40, this.h/2 - 10)
    text("angle (deg)", 10, -10)

    // data points
    noFill()
    strokeWeight(2)
    stroke("#2AA198")
    beginShape();
    for (let i = 0; i < 1000; i++) {
      const t = i * 0.01;
      const tMapped = map(t, 0, 10, 0, this.w)
      const yMapped = map(simulation.data[i], -PI/4, PI/4, this.h, 0)
      vertex(tMapped, yMapped)
    }
    endShape()

    if (mouseX > this.x && mouseX < this.x + this.w && mouseY > this.y && mouseY < this.y + this.h && mouseIsPressed) {
      const t = mouseX - this.x;
      const index = round(map(t, 0, this.w, 0, 1000))
      const y = simulation.data[index]
      const yMapped = map(y, -PI/4, PI/4, this.h, 0)

      // guide
      stroke("#6C6C6C")
      strokeWeight(2)
      line(t, 0, t, this.h)
      strokeWeight(1)
      text(index/1000 + " s", t - 16, this.h + 25)

      // current point
      stroke("#CB4B16")
      strokeWeight(8)
      point(t, yMapped)

      state.angleGraphHover = true
      state.angleGraphTheta = y
      state.timerRunning = false
    }
    else if (state.timerRunning) {
      const y = simulation.data[timer.index];
      const yMapped = map(y, -PI/4, PI/4, this.h, 0)
      const t = timer.t
      const tMapped = map(t, 0, 10, 0, this.w)

      // current point
      stroke("#CB4B16")
      strokeWeight(8)
      point(tMapped, yMapped)
    }
    else {
      const start = map(simulation.data[0], -PI/4, PI/4, this.h, 0)

      // current point
      stroke("#CB4B16")
      strokeWeight(8)
      point(0, start)

      state.angleGraphHover = false
    }

    pop()
  }
}

class EnergyGraph {
  constructor(x, y, w, h) {
    this.x = x
    this.y = y
    this.w = w
    this.h = h

    this.total = this.potential = this.kinetic = 0
  }

  draw() {
    push()

    translate(this.x, this.y)

    // baseline
    noFill()
    stroke("#6C6C6C")
    strokeWeight(2)
    line(20, this.h, this.w - 20, this.h)

    this.total = this.calculatePotential(simulation.theta0)

    if (state.angleGraphHover) {
      this.potential = this.calculatePotential(state.angleGraphTheta)
    }
    else if (state.timerRunning) {
      this.potential = this.calculatePotential(simulation.data[timer.index])
    }
    else {
      this.potential = this.calculatePotential(simulation.theta0)
    }

    this.kinetic = this.total - this.potential

    const maxEnergy = 2 * PI/4 * g
    const potentialMapped = map(this.potential, 0, maxEnergy, this.h, 0)
    const kineticMapped = map(this.kinetic, 0, maxEnergy, this.h, 0)
    const totalMapped = map(this.total, 0, maxEnergy, this.h, 0)

    // bars
    noStroke()
    fill("#CB4B16")
    rect(this.w/3 - 15, potentialMapped, 30, this.h - potentialMapped)
    fill("#2AA198")
    rect(2*this.w/3 - 15, kineticMapped, 30, this.h - kineticMapped)

    // topline
    stroke("#6C6C6C")
    strokeWeight(2)
    line(20, totalMapped, this.w - 20, totalMapped)

    // text
    fill("#6C6C6C")
    textSize(14)
    strokeWeight(1)
    text("U", this.w/3 - 5, this.h + 20)
    text("K", 2*this.w/3 - 5, this.h + 20)
    text("T", this.w - 10, totalMapped + 5)

    pop()
  }

  calculatePotential(theta) {
    const h = simulation.l - simulation.l * cos(theta)
    return simulation.m * g * h
  }

  calculateKinetic(theta) {
    const l = simulation.l, m = simulation.m, theta0 = simulation.theta0
    const velocity = - sqrt(g/l) * sqrt(sq(theta0) - sq(theta))
    return 1/2.0 * m * sq(velocity)
  }
}
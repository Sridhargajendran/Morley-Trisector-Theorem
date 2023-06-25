let p1, p2, p3;
let xoff1 = 0;
let yoff1 = 1000;

function setup() {
  createCanvas(600, 600);

  p1 = new Point(random(width), random(height));
  p2 = new Point(random(width), random(height));
  p3 = new Point(random(width), random(height));
}

function draw() {
  background(255);

  p1.show();
  p2.show();
  p3.show();

  stroke(0);
  strokeWeight(2);
  line(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
  line(p2.pos.x, p2.pos.y, p3.pos.x, p3.pos.y);
  line(p3.pos.x, p3.pos.y, p1.pos.x, p1.pos.y);

  let first = drawTrisectors(p1, p2, p3);
  let second = drawTrisectors(p2, p1, p3);
  let third = drawTrisectors(p3, p2, p1);

  let point1 = findIntersection(p1, first[0], p2, second[0]);
  let point2 = findIntersection(p2, second[1], p3, third[0]);
  let point3 = findIntersection(p3, third[1], p1, first[1]);

  stroke(0, 100);
  line(p1.pos.x, p1.pos.y, point1.x, point1.y);
  line(p2.pos.x, p2.pos.y, point1.x, point1.y);
  line(p2.pos.x, p2.pos.y, point2.x, point2.y);
  line(p3.pos.x, p3.pos.y, point2.x, point2.y);
  line(p3.pos.x, p3.pos.y, point3.x, point3.y);
  line(p1.pos.x, p1.pos.y, point3.x, point3.y);

  stroke(color('#367304'));
  strokeWeight(2);
  fill(color('#6ACB1A'), 200);
  beginShape();
  vertex(point1.x, point1.y);
  vertex(point2.x, point2.y);
  vertex(point3.x, point3.y);
  endShape(CLOSE);

  p1.setPos(noise(xoff1) * width, noise(yoff1) * height);

  xoff1 += 0.001;
  yoff1 += 0.001;
}

function findIntersection(one, list1, other, list2) {
  let x1 = one.pos.x;
  let y1 = one.pos.y;
  let x2 = list1.x;
  let y2 = list1.y;

  let x3 = other.pos.x;
  let y3 = other.pos.y;
  let x4 = list2.x;
  let y4 = list2.y;

  let den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  let t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;

  let p = new p5.Vector();
  p.x = x1 + t * (x2 - x1);
  p.y = y1 + t * (y2 - y1);

  return p;
}

function drawTrisectors(middle, one, other) {
  let trisectors = [];

  let mid = new p5.Vector(middle.pos.x, middle.pos.y);
  let first = new p5.Vector(one.pos.x, one.pos.y);
  let firstreq = p5.Vector.sub(first, mid);
  let second = new p5.Vector(other.pos.x, other.pos.y);
  let secondreq = p5.Vector.sub(second, mid);

  let angle = firstreq.angleBetween(secondreq);

  let firstline = firstreq.copy();
  let secondline = firstreq.copy();

  let orientation = firstreq.cross(secondreq);

  if (orientation.z < 0) {
    firstline.rotate(angle * (1 / 3));
    secondline.rotate(angle * (2 / 3));
  } else {
    firstline.rotate(angle * (1 / 3));
    secondline.rotate(angle * (2 / 3));
  }

  firstline.add(mid);
  secondline.add(mid);

  trisectors[0] = firstline;
  trisectors[1] = secondline;

  return trisectors;
}

function mouseDragged() {
  p2.ifContains(mouseX, mouseY);
  p3.ifContains(mouseX, mouseY);
}

class Point {
  constructor(x, y) {
    this.pos = new p5.Vector(x, y);
    this.r = 25;
  }

  setPos(nx, ny) {
    this.pos.set(new p5.Vector(nx, ny));
  }

  ifContains(mx, my) {
    let mousePos = new p5.Vector(mx, my);

    let d = dist(this.pos.x, this.pos.y, mx, my);

    if (d < this.r) {
      this.pos.set(mousePos);
    }
  }

  show() {
    fill(color('#F207BD'), 150);
    stroke(color('#7E1967'));
    strokeWeight(4);
    ellipse(this.pos.x, this.pos.y, this.r, this.r);
  }
}

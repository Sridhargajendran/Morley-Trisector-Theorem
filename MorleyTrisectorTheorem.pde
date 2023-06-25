Point p1, p2, p3;
float xoff1 = 0;
float yoff1 = 1000;

void setup() {
  size(1000, 1000);
  smooth();

  p1 = new Point(random(width), random(height));
  p2 = new Point(random(width), random(height));
  p3 = new Point(random(width), random(height));
}

void draw() {
  background(255);

  p1.show();
  p2.show();
  p3.show();

  stroke(0);
  strokeWeight(2);
  line(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
  line(p2.pos.x, p2.pos.y, p3.pos.x, p3.pos.y);
  line(p3.pos.x, p3.pos.y, p1.pos.x, p1.pos.y);

  PVector[] first = drawTrisectors(p1, p2, p3);
  PVector[] second = drawTrisectors(p2, p1, p3);
  PVector[] third = drawTrisectors(p3, p2, p1);

  PVector point1 = findIntersection(p1, first[0], p2, second[0]);
  PVector point2 = findIntersection(p2, second[1], p3, third[0]);
  PVector point3 = findIntersection(p3, third[1], p1, first[1]);

  stroke(0, 100);
  line(p1.pos.x, p1.pos.y, point1.x, point1.y);
  line(p2.pos.x, p2.pos.y, point1.x, point1.y);
  line(p2.pos.x, p2.pos.y, point2.x, point2.y);
  line(p3.pos.x, p3.pos.y, point2.x, point2.y);
  line(p3.pos.x, p3.pos.y, point3.x, point3.y);
  line(p1.pos.x, p1.pos.y, point3.x, point3.y);

  stroke(#367304);
  strokeWeight(2);
  fill(#6ACB1A, 200);
  beginShape();
  vertex(point1.x, point1.y);
  vertex(point2.x, point2.y);
  vertex(point3.x, point3.y);
  endShape(CLOSE);

  p1.setPos(noise(xoff1) * width, noise(yoff1) * height);

  xoff1 += 0.001;
  yoff1 += 0.001;
}

PVector findIntersection(Point one, PVector list1, Point other, PVector list2) {
  float x1 = one.pos.x;
  float y1 = one.pos.y;
  float x2 = list1.x;
  float y2 = list1.y;

  float x3 = other.pos.x;
  float y3 = other.pos.y;
  float x4 = list2.x;
  float y4 = list2.y;

  float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

  float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;

  PVector p = new PVector();
  p.x = x1 + t * (x2 - x1);
  p.y = y1 + t * (y2 - y1);

  return p;
}

PVector[] drawTrisectors(Point middle, Point one, Point other) {
  PVector[] trisectors = new PVector[2];

  PVector mid = new PVector(middle.pos.x, middle.pos.y);
  PVector first = new PVector(one.pos.x, one.pos.y);
  PVector firstreq = PVector.sub(first, mid);
  PVector second = new PVector(other.pos.x, other.pos.y);
  PVector secondreq = PVector.sub(second, mid);

  float angle = PVector.angleBetween(firstreq, secondreq);

  PVector firstline = firstreq.copy();
  PVector secondline = firstreq.copy();

  PVector orientation = firstreq.cross(secondreq);

  if (orientation.z < 0) {
    firstline.rotate(-angle * 1 / 3);
    secondline.rotate(-angle * 2 / 3);
  } else {
    firstline.rotate(angle * 1 / 3);
    secondline.rotate(angle * 2 / 3);
  }

  firstline.add(mid);
  secondline.add(mid);

  trisectors[0] = firstline;
  trisectors[1] = secondline;

  return trisectors;
}

void mouseDragged() {
  //p1.ifContains(mouseX, mouseY);
  p2.ifContains(mouseX, mouseY);
  p3.ifContains(mouseX, mouseY);
}

class Point {
  PVector pos;
  float r;

  Point(float x, float y) {
    pos = new PVector(x, y);
    r = 25;
  }

  void setPos(float nx, float ny) {
    pos.set(new PVector(nx, ny));
  }

  void ifContains(float mx, float my) {
    PVector mousePos = new PVector(mx, my);

    float d = dist(pos.x, pos.y, mx, my);
    if (d < r) {
      pos.set(mousePos);
    }
  }

  void show() {
    fill(#F207BD, 150);
    stroke(#7E1967);
    strokeWeight(4);
    ellipse(pos.x, pos.y, r, r);
  }
}

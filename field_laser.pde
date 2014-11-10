// To add new laser types: Change ship.shoot() and laser()
/*
  List of laser Types: - per/s - dist
 0 - Standard - White  - 6     - 288
 1 - Double   - Lime   - 10    - 144
 2 - Triple   - Orange - 5     - 480
 3 - Penta    - Green  - 6     - 96
 4 - CHAOSGUN - Blue   - 5     - 
 5 - Beam     - Purple - 7.5     - 288
 6 - Railgun  - Red    - 2.5   - 3600
 7 - Splitter - Yellow - 2     - 480
 */

boolean[] arsenal = {
  true, false, false, false, 
  false, false, false, false
};
int[] laserlife = {
  48, 36, 60, 8, 48, 2, 120, 60
};
int[] lasercolor = {
  color(255), color(80, 255, 80), 
  color(255, 128, 0), color(0, 128, 0), 
  color(0, 0, 255), color(160, 0, 255), 
  color(255, 0, 0), color(255, 255, 0)
};
int[] laserfire = {
  10, 6, 
  12, 10, 
  12, 8, 
  24, 30
};
int[] laservel = {
  6, 4, 
  8, 12, 
  6, 16, 
  30, 8
};

String[] names = {
  "[1] Standard", "[2] Double", 
  "[3] Triple", "[4] Burst", 
  "[5] CHAOSGUN", "[6] Beam", 
  "[7] Railgun", "[8] Splitter"
};

class Laser extends Object {
  int lifetime;

  Laser(float tx, float ty, float tang) {
    laser(tx, ty, tang, mercury.type);
  }
  Laser(float tx, float ty, float tang, int tt) {
    laser(tx, ty, tang, tt);
  }

  void laser(float tx, float ty, float tang, int tt) {
    // Sets location and velocity
    pos = new PVector(tx, ty);
    type = tt;
    float vel = laservel[type];
    radius = SCALE*vel/2;
    lifetime = laserlife[type];
    switch(type) {
    case 0:
      dir = tang + random(-PI/64, PI/64);
      break;
    case 1:
      dir = tang + random(-PI/12, PI/12);
      break;
    case 2:
      dir = tang;
      break;
    case 3:
      dir = tang + random(-PI/12, PI/12);
      break;
    case 4:
      dir = tang + random(-PI/64, PI/64);
      break;
    case 5:
      dir = tang + random(-PI/64, PI/64);
      break;
    case 6:
      dir = tang;
      break;
    case 7:
      dir = tang;
      break;
    }
    last = new PVector(tx+SCALE*cos(dir)*vel, ty+SCALE*sin(dir)*vel);
    // Sets checks
    checks = ceil(radius/(2*CELLSIZE));
    // Initializes location cell list
    loc = new ArrayList();
    // Initializes list of objects already interacted with
    collided = new ArrayList();

    // Updates loc and cells
    update();

    // Adds this object to actors
    // actors.add(this);
  }

  void tick() {
    lifetime--;
    if (lifetime < 1)
      if (!removal.contains(this))
        removal.add(this);
    collided.clear();
    // Temp for setting last location
    PVector temppos = new PVector(pos.x, pos.y);

    // Verlet integration formulas for discrete physics simulations
    // v = ds/dt
    pos.set(2*pos.x - last.x, 
    2*pos.y - last.y);
    last.set(temppos.x, temppos.y);

    if (frameCount%8 == 0)
      if (type == 7) 
        for (int i = 0; i < 4; i++) {
          Laser temp = new Laser(pos.x, pos.y, dir+PI/4+PI/2*i, 0);
          temp.lifetime = 18;
          addition.add(temp);
        }

    // Checks and does collisions with other balls
    // Gets objects with shared locations
    ArrayList<Object> tempCol = scene.collide(this);
    for (Object o : tempCol)
      // Makes sure to not collide with same object more than once
      if (!collided.contains(o)) {
        collided.add(o);
        o.collided.add(o);
        // Checks if two objects are touching by radii and does collision
        // Changes location in edge cases
        float tx1 = this.pos.x - (this.pos.x - o.pos.x > width/2 ? width : 0);
        float ty1 = this.pos.y - (this.pos.y - o.pos.y > height/2 ? height : 0);
        float tx2 = o.pos.x - (o.pos.x - this.pos.x > width/2 ? width : 0);
        float ty2 = o.pos.y - (o.pos.y - this.pos.y > height/2 ? height : 0);
        if (dist(tx1, ty1, tx2, ty2) < (this.radius+o.radius)/2)
          this.collide(o);
      }

    // Boundary Checking
    if (pos.x < 0) {
      last.set(last.x + width, last.y);
      pos.set(pos.x + width, pos.y);
    } else if (pos.x > width) {
      last.set(last.x - width, last.y);
      pos.set(pos.x - width, pos.y);
    }
    if (pos.y < 0) {
      last.set(last.x, last.y + height);
      pos.set(pos.x, pos.y + height);
    } else if (pos.y > height) {
      last.set(last.x, last.y - height);
      pos.set(pos.x, pos.y - height);
    }

    update();
  }

  void show() {
    if (showCells) {
      noStroke();
      fill(25, 128, 128, 64);
      ellipse(0, 0, radius, radius);
    }
    stroke(lasercolor[type]);
    strokeWeight(SCALE*2);
    noFill();
    beginShape();
    vertex(pos.x, pos.y);
    vertex(last.x, last.y);
    endShape();
  }

  void collide(Object o) {
    if (o instanceof Asteroid) {
      if (!removal.contains(this)) {
        if (o.type != 3) {
          if (type != 6)
            removal.add(this);
          else
            lifetime -= 12;
        } else {
          float tempvel = dist(pos.x, pos.y, last.x, last.y);
          float phi1 = atan2(last.y-pos.y, last.x-pos.x);
          float theta = atan2(pos.y-o.pos.y, pos.x-o.pos.x);
          float phi2 = 2*theta-phi1;
          last.set(pos.x-tempvel*cos(phi2), pos.y-tempvel*sin(phi2));
        }
      }
      if (o.type != 2 && o.type != 3) {
        if (!removal.contains(o))
          removal.add(o);
      } else o.collide(this);
    }
  }
}


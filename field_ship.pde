final float shipSize = 12; // Unscaled ship size
int cooldown; // Firerate Cooldown
float turnSpeed = PI/45;

void checkFire() { // Fires lasers when spacebar is pressed
  if (firekey && cooldown == 0 && !dead) { // When cooldown is 0, lasers are ready to fire
    if (!debug)
      stats[1]++;
    if (mercury != null) {
      mercury.shoot(mercury.type);
      cooldown = laserfire[mercury.type];
    }
  }
  if (cooldown > 0)
    cooldown--;
}

class Ship extends Object {
  PVector vel; // Velocity is stored for ship
  // Not for movement calculations but instead for screen following

  Ship(float tx, float ty) {
    // Sets location and velocity, static radius
    pos = new PVector(tx, ty);
    last = new PVector(tx, ty);
    radius = shipSize*SCALE;
    dir = random(0, 2*PI);

    vel = new PVector(pos.x - last.x, pos.y - last.y);


    cooldown = 0;
    type = 0;

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
    collided.clear();

    // Turning
    if (leftkey)
      dir -= turnSpeed;
    else if (rightkey)
      dir += turnSpeed;

    if (upkey)
      last.add(SCALE*cos(dir)*0.1, SCALE*sin(dir)*0.1, 0);

    // Temp for setting last location
    PVector temppos = new PVector(pos.x, pos.y);
    vel = new PVector(pos.x - last.x, pos.y - last.y);
    vel.mult(FRICTION);
    float tempSpd = dist(0, 0, vel.x, vel.y);

    // Verlet integration formulas for discrete physics simulations
    // v = ds/dt
    pos.add(vel);
    last.set(temppos.x, temppos.y);

    // Checks and does collisions with other balls
    // Gets objects with shared locations
    ArrayList<Object> tempCol = scene.collide(this);
    for (Object o : tempCol)
      // Makes sure to not collide with same object more than once
      if (!collided.contains(o)) {
        collided.add(o);
        o.collided.add(o);
        // Checks if two objects are touching by radii and does collision
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

    // Engine particle effects
    effects.add(new Spark(pos.x+cos(dir)*(radius/2+2*SCALE), pos.y+sin(dir)*(radius/2), SCALE*random(tempSpd+16, tempSpd*2+16), color(random(200, 300)%255, 255, 255), random(15*GRAPHICS, 20*GRAPHICS), dir+random(-PI/3, PI/3)));

    update();
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir);

    if (showCells) {
      noStroke();
      fill(75, 128, 128);
      ellipse(0, 0, radius, radius);
    }

    stroke(lasercolor[type]);
    strokeWeight(SCALE*2);
    fill(0);
    beginShape();
    vertex(-radius, 0);
    vertex(2*radius/3, 2*radius/3);
    vertex(2*radius/3, -2*radius/3);
    vertex(-radius, 0);
    endShape();
    popMatrix();
  }

  void collide(Object o) {
    if (o instanceof Asteroid) {
      if (!removal.contains(o))
        removal.add(o);
      if (!paused)
        death();
    }
  }

  void shoot(int tt) { // Switch case for laser type
    switch(tt) {
    case 0:
      actors.add(new Laser(pos.x, pos.y, dir, tt));
      break;
    case 1:
      actors.add(new Laser(pos.x, pos.y, dir+PI/12, tt));
      actors.add(new Laser(pos.x, pos.y, dir-PI/12, tt));
      break;
    case 2:
      actors.add(new Laser(pos.x, pos.y, dir+PI/16, tt));
      actors.add(new Laser(pos.x, pos.y, dir, tt));
      actors.add(new Laser(pos.x, pos.y, dir-PI/16, tt));
      break;
    case 3:
      actors.add(new Laser(pos.x, pos.y, dir+PI/8, tt));
      actors.add(new Laser(pos.x, pos.y, dir+PI/16, tt));
      actors.add(new Laser(pos.x, pos.y, dir, tt));
      actors.add(new Laser(pos.x, pos.y, dir-PI/16, tt));
      actors.add(new Laser(pos.x, pos.y, dir-PI/8, tt));
      break;
    case 4:
      shoot(int(random(8)));
      break;
    case 5:
      for (int i = 0; i < 18; i++) // Generates 12 lasers in a straight line for beam laser
        actors.add(new Laser(pos.x-i*SCALE*cos(dir)*16, pos.y-i*SCALE*sin(dir)*16, dir, tt));

      break;
    case 6:
      actors.add(new Laser(pos.x, pos.y, dir, tt));
      break;
    case 7:
      actors.add(new Laser(pos.x, pos.y, dir, tt));
      break;
    }
  }
}


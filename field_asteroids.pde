/*
  0 - Standard - White - Run-of-the-mill Asteroid
 1 - Seeker? (Need to write algorithm)
 2 - Rager (Gets faster as it's hit)
 3 - Repulsor (Reflects lasers)
 4 - Goodie Bad (Drops Powerups)
 
 
 */

int[] astfreq = {
  3, 13, 19, 29, 25
};
int[] astcolor = {
  color(255), color(255, 128, 0), color(160, 0, 255), color(0, 128, 255), color(0, 192, 0)
};

void spawnAst(int tt, int smin, int smax) {
  if (asteroidNum () < ASTEROIDNUM)
    if (mercury != null)
      actors.add(new Asteroid(random(mercury.pos.x+width/4, mercury.pos.x+3*width/4), random(mercury.pos.y+height/4, mercury.pos.y+3*height/4), random(smin, smax), tt, random(0, 2*PI)));
}

class Asteroid extends Object {

  // The geometry of the asteroid
  float[] vertx = new float[GRAPHICS*4];
  float[] verty = new float[GRAPHICS*4];

  int life;

  Asteroid(float tx, float ty, float ts, int tt, float td) {
    // Sets location and velocity, static radius
    pos = new PVector(tx, ty);
    ang = td;
    radius = ts*SCALE;
    last = new PVector(tx+48/radius*cos(ang)*sq(SCALE), ty+48/radius*sin(ang)*sq(SCALE));
    dir = random(-1, 1);
    type = tt;

    if (type == 2)
      life = 8;
    else if (type == 3)
      life = 12;
    // Sets checks
    checks = ceil(radius/(2*CELLSIZE));
    // Initializes location cell list
    loc = new ArrayList();
    // Initializes list of objects already interacted with
    collided = new ArrayList();

    // Sets the vertices of the asteroid to an random 16 sided polygon
    for (int i = 0; i < 4*GRAPHICS; i++) {
      float temp;
      if (type != 3)
        temp = random(radius/4, radius/2);
      else
        temp = random(radius/2.2, radius/2);
      // The vertices are generated radially
      // A vertice is generated at an angle of 0 with a random distance from the center of the asteroid
      // Then the next vertice is PI/8 radians rotated from the previous one and generated with a new random distance from the center
      vertx[i] = sin(i*PI/(2*GRAPHICS))*temp;
      verty[i] = cos(i*PI/(2*GRAPHICS))*temp;
    }

    // Updates loc and cells
    update();

    // Adds this object to actors
    // actors.add(this);
  }

  void tick() {
    if (dir < 0)
      dir -= .01;
    else
      dir += .01;

    if (type == 1)
      if (mercury != null) {
        float tx1 = this.pos.x - (this.pos.x - mercury.pos.x > width/2 ? width : 0);
        float ty1 = this.pos.y - (this.pos.y - mercury.pos.y > height/2 ? height : 0);
        float tx2 = mercury.pos.x - (mercury.pos.x - this.pos.x > width/2 ? width : 0);
        float ty2 = mercury.pos.y - (mercury.pos.y - this.pos.y > height/2 ? height : 0);

        float seek = atan2(ty1 - ty2, tx1 - tx2);

        ang = seek;

        this.last.add(SCALE*sin(seek)*.01, SCALE*sin(seek)*.01, 0);
      }

    // Temp for setting last location
    PVector temppos = new PVector(pos.x, pos.y);

    // Verlet integration formulas for discrete physics simulations
    // v = ds/dt
    pos.set(pos.x + (pos.x - last.x), 
    pos.y + (pos.y - last.y));
    last.set(temppos.x, temppos.y);

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
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir);

    if (showCells) {
      noStroke();
      fill(25, 128, 128, 64);
      ellipse(0, 0, radius, radius);
    }

    stroke(astcolor[type]);
    strokeWeight(SCALE*2);
    fill(0);
    beginShape();
    for (int i = 0; i < 4*GRAPHICS || paused; i++)
      vertex(vertx[i], verty[i]);
    vertex(vertx[0], verty[0]);
    endShape();
    popMatrix();
  }

  void collide (Object o) {
    if (this.type == 2) {
      life--;
      last.add(cos(ang)*SCALE*.6, sin(ang)*SCALE*.6, 0);
    } else if (this.type == 3) {
      life--;
    }
    if (life == 0)
      if (!removal.contains(this))
        removal.add(this);
  }
}


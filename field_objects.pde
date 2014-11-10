// Game elements

/*
  Ship
 Asteroids
 */

Ship mercury;

void setupElements() { 
  mercury = new Ship(width/2, height/2);
  actors.add(mercury); // No other actors need to be set up at the start
  for (int i = 1; i < 8; i++)
    arsenal[i] = false;
}


// Object superclass
abstract class Object {
  // Location of the object
  PVector pos;
  // Is actually the diameter of the object
  float radius;
  // Last position of the object (used for verlet integration)
  PVector last;
  // Direction the object is facing
  float dir;
  // Number of cells in each direction to check for occupancy
  int checks;
  // List of cells that contain this object
  ArrayList<Cell> loc;
  ArrayList<Object> collided;

  // Direction of movement for asteroids
  float ang;

  // Type is put here to be able to call the value from removal
  int type;

  Object() {
  }

  // Should happen every frame
  void tick() {
    update();
  }

  // Updates cells loc
  void update() {
    // Removes this object from old cells
    for (Cell c : loc)
      c.remove(this);

    // Clears location
    loc.clear();

    // Adds current cells to location
    for (int i = -checks; i <= checks; i++)
      for (int j = -checks; j <= checks; j++) {
        Cell tempc = scene.getCell(pos.x+i*CELLSIZE, pos.y+j*CELLSIZE);
        if (tempc != null)
          if (!loc.contains(tempc))
            loc.add(tempc);
      }

    // Adds this object to new cells
    for (Cell c : loc)
      c.add(this);
  }

  void render() {
    /* shows an object nultiple times if it is near edges
     The play field is exactly the size of the display screen so objects near the 
     edges of the play field need to be rendered on the other side of the play field.
     Can render an object a maximum of 4 times
     There are 8 cases where an object would need to be rerendered */
    show();
    pushMatrix();
    if (pos.x > width+origin.x-radius) { // Right side case
      translate(-width, 0);
      show();
      if (pos.y > height+origin.y-radius) { // Right lower corner case
        translate(0, -height);
        show();
      } else if (pos.y < radius+origin.y) { // Right upper corner case
        translate(0, height);
        show();
      }
    } else if (pos.x < radius+origin.x) { // Left side cases
      translate(width, 0);
      show();
      if (pos.y > height+origin.y-radius) { // Left lower corner case
        translate(0, -height);
        show();
      } else if (pos.y < radius+origin.y) { // Left upper corner case
        translate(0, height);
        show();
      }
    }
    popMatrix();
    pushMatrix();
    if (pos.y > height+origin.y-radius) { // Lower side case
      translate(0, -height);
      show();
    } else if (pos.y < radius+origin.y) { // Upper side case
      translate(0, height);
      show();
    }
    popMatrix();
  }

  // Draws the physical object onto the screen
  void show() {
  }

  // What actually occurs when an object collides with another
  void collide(Object o) {
  }
}


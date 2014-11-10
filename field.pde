// Hitscan based on arrays of cells

// Static Global Variables
// Number of cells 16x9
final int FIELDX = 48;
final int FIELDY = 27;
// Size of cells in px
int CELLSIZE;

Field scene; // Or stage?
ArrayList<Object> actors;

// List of objects to be removed
ArrayList<Object> removal;

// List of objects to be added
ArrayList<Object> addition;

// Location of screen corner
PVector origin;

int overlayOpacity = 0;
String overlayText = "";

void setupField() {
  //size(FIELDX*CELLSIZE, FIELDY*CELLSIZE);
  //println("Width: "+width+" Height: "+height);

  CELLSIZE = int(SCALE*16);
  // Constructing objects
  scene = new Field();
  actors = new ArrayList();
  removal = new ArrayList();
  addition = new ArrayList();
  origin = new PVector(0, 0);
} // Called in game_flow.resetGame()

void renderField() { // Most of the game occurs here
  /* 
   Since objects cannot remove themself from actors in the Object.render() function, 
   they just add themself to an arrayList called removal instead. Lol
   */
  for (int i = removal.size ()-1; i >= 0; i--) { 
    Object temp = removal.get(i);

    if (temp instanceof Asteroid) { 
      // Explosions were moved here to prevent multiple explosions from happening from one asteroid that collided with multiple lasers in one frame.
      // This problem occurred in the previous asteroids too where the beam laser would spawn numerous asteroids from one collision
      if (EXPLOSIONS) 
        effects.add(new Explosion(temp.pos.x, temp.pos.y, temp.radius/3));
      shake.set(shake.x+signum(random(-1, 1))*temp.radius/64, shake.y+signum(random(-1, 1))*temp.radius/64);

      // This will be changed later for different asteroid types
      if (temp.radius > 32*SCALE && temp.type != 2 && temp.type != 3 && temp.type != 4)
        actors.add(new Asteroid(temp.pos.x, temp.pos.y, temp.radius/(2*SCALE), temp.type, temp.ang));
      if (temp.type == 4) {
        ArrayList<Integer> tempp = new ArrayList();
        for (int j = 0; j < 8; j++)
          if (!arsenal[j])
            tempp.add(j);
        if (tempp.size() > 0) {
          int temppp = tempp.get(int(random(tempp.size())));
          arsenal[temppp] = true;
          overlayText = names[temppp];
          overlayOpacity = 200;
        }
      }
      if (!dead)
        score++;
      if (!debug)
        stats[2]++;
      if (score%astfreq[0] == 0)
        spawnAst(0, 80, 128);
      if (score%astfreq[1] == 0)
        spawnAst(1, 80, 128);
      if (score%astfreq[2] == 0)
        spawnAst(2, 128, 160);
      if (score%astfreq[3] == 0)
        spawnAst(3, 128, 160);
      if (score%astfreq[4] == 0)
        spawnAst(4, 128, 128);
    }

    // The removal happens here
    for (int j = temp.loc.size ()-1; j >= 0; j--) // Location must be cleaned of the object first
      temp.loc.get(j).contains.remove(temp);
    actors.remove(temp);
  }
  removal.clear(); // I forgot to add this before, and a million asteroids were spawning every time an asteroid broke


  for (Object o : addition)
    actors.add(o);
  addition.clear();
  // Shade occupied cells
  if (showCells) 
    scene.renderCells();
  // Shows a green border around the active play field. 
  // Objects that are shown outside this rectangle aren't actually where they are shown, they are only rendered there
  if (showGrid) {
    strokeWeight(SCALE*2);
    stroke(75, 255, 255);
    noFill();
    rect(0, 0, width, height);

    // Draws a big green dot in the top left corner
    // Obsolete now, but helped to test the screen following
    fill(75, 255, 255);
    ellipse(origin.x, origin.y, 32*SCALE, 32*SCALE);
  }
  if (mercury != null) {
    fill(75, 255, 192, overlayOpacity);
    textFont(f36);
    text(overlayText, mercury.pos.x-overlayText.length()*13.2, mercury.pos.y-16);
  }
  if (overlayOpacity > 0)
    overlayOpacity -= 2;

  // Firing lasers happens here
  // Can't think of a better place to put it
  checkFire();

  // Ticking then rendering actors
  for (Object o : actors)
    o.tick();
  for (Object o : actors)
    o.render();
} // Called in game_flow.play()

// The area in which objects exist
class Field {
  // Container for the Field's cells
  ArrayList<ArrayList<Cell>> world;

  // Constructor
  Field() {
    // Adds cells to world
    world = new ArrayList();
    for (int i = 0; i < FIELDX; i++) {
      world.add(new ArrayList());
      for (int j = 0; j < FIELDY; j++) {
        world.get(i).add(new Cell(i, j));
      }
    }
  }

  // Returns a cell at a specific location
  Cell getCell(float x, float y) {
    // if (x >= 0 && x < FIELDX*CELLSIZE && y >= 0 && y < FIELDY*CELLSIZE)
    return world.get((floor(x/CELLSIZE)+FIELDX)%FIELDX).get((floor(y/CELLSIZE)+FIELDY)%FIELDY);
    // else return null;
  }

  // Returns a list of objects with the same collision cells
  ArrayList<Object> collide(Object o) {
    ArrayList<Object> ret = new ArrayList();
    for (Cell c : o.loc)
      for (Object ob : c.contains)
        if (!ret.contains(ob))
          ret.add(ob);
    // Removes self from list
    if (ret.contains(o))
      ret.remove(o);
    return ret;
  }

  // Debug method, shades occupied cells
  void renderCells() {
    for (int i = 0; i < FIELDX; i++)
      for (int j = 0; j < FIELDY; j++) {
        noStroke();
        fill(world.get(i).get(j).contains.size()*32, 64);
        rect(i*CELLSIZE, j*CELLSIZE, CELLSIZE, CELLSIZE);
      }
  }
}

// Cell class
class Cell {
  // List of objects contained within the cell
  ArrayList<Object> contains;
  // Index of field.world that represents the cell
  int xi;
  int yi;

  // Constructor
  Cell(int tx, int ty) {
    contains = new ArrayList();
    xi = tx;
    yi = ty;
  }

  // Add and remove objects from the cell
  void add(Object o) {
    contains.add(o);
  }
  void remove(Object o) { 
    contains.remove(o);
  }
}


// Single core, 2.3GHz (Processing doesn't allow multi-core rendering?) (Benchmarks are outdated)
// Program has insifnificant RAM usage. 256 MB works fine. Not tested with 128 MB setting. 
// Screen scale           1    1    1    2    2  1.5
// Graphics setting       4    4    1    1    4    1
// Asteroid cap         160  240  240  160  160  160
// Framerate stabilized  56   39   60   42   28   57
// Framerate Explosions  55   33   58   38   22   55
// Recommended?           Y    N    Y    N    N    Y
// Explosions enabled?    Heck yeah

// SWIDTH and SHEIGHT should NEVER be changed.
// To change screen size, change scale instead.
// Screen size cannot be changed during sketch runtime.
final float SWIDTH = 1280;  // FIELDX*16
final float SHEIGHT = 720; // FIELDY*16
final float SCALE = 1;
/* 
 Scale calculations for effects are done within the constructors.
 */

// Graphics, Showcells, Asteroid num, explosions can be changed during runtime
boolean showCells = false;
boolean showGrid = false;
// Debug mode
boolean debug = false;
boolean showFPS = false;
int GRAPHICS = 4;
/* Amount of effects
 1 = min
 2 = med
 4 = high
 */
// Initial number of asteroids
int INITAST = 4;
// Hard capped asteroid number to improve framerate
int ASTEROIDNUM = 128;
boolean EXPLOSIONS = true;
// I don't know why I added this option. 
// Explosions should always be enabled in order to fully enjoy this game.
final float FRICTION = 0.98;
// Asteroid despawn size threshhold
float despawn = 16;

void saveOptions() {
  int[] temp1 = new int[5];
  temp1[0] = GRAPHICS;
  if(debug)
    temp1[1] = 1;
    else temp1[1] = 0;
  if(showCells)
    temp1[2] = 1;
    else temp1[2] = 0;
  if(showGrid)
    temp1[3] = 1;
    else temp1[3] = 0;
  if(showFPS)
    temp1[4] = 1;
    else temp1[4] = 0;
    
  String temp2[] = {
    join(nf(temp1, 0), ',')
  };
  saveStrings("data/settings.txt", temp2);
}

void readOptions() {
  int[] temp = int(split(loadStrings("settings.txt")[0], ','));
  GRAPHICS = temp[0];
  if(temp[1] == 1)
    debug = true;
    else debug = false;
  if(temp[2] == 1)
    showCells = true;
    else showCells = false;
  if(temp[3] == 1)
    showGrid = true;
    else showGrid = false;
  if(temp[4] == 1)
    showFPS = true;
    else showFPS = false;
}


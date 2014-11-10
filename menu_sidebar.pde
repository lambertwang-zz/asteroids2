class SideBar {
  float pos;
  float target;
  float neutral; // Position when not being hovered
  int side;
  // -1 = left
  // 1 = right
  int type;
  float speed;

  SideBar(float ttar, float tn, int tt) {
    pos = tn;
    target = ttar;
    neutral = tn;
    side = int(signum(neutral - target));
    type = tt;
    speed = (neutral - target)/20;
  }

  void render() {
    if (mouseX*side > pos*side && pos*side > target*side)
      pos -= speed;
    else if (pos*side < neutral*side && mouseX*side < pos*side)
      pos += speed;

    switch(type) {
    case 0:
      instructions(pos);
      break;
    }
  }
}

void instructions(float x) {
  fill(0);
  strokeWeight(2.5*SCALE);
  stroke(75, 255, 192);
  rect(x, -3*SCALE, width+3*SCALE, height+3*SCALE);
  pushMatrix();
  translate(x+28, 216);
  rotate(-PI/2);
  textFont(f24);
  fill(75, 255, 192);
  text("INSTRUCTIONS", 0, 0);
  popMatrix();
  pushMatrix();
  translate(x+36, 0);
  text("Up Arrow:",12, 28);
  text("Accelerate", 24, 56);
  text("Left/Right:", 12, 92);
  text("Turn", 24, 120);
  text("F Key:", 12, 156);
  text("Fire", 24, 184);
  text("P Key:", 12, 220);
  text("Pause/unpause", 24, 248);
  text("R Key:", 12, 284);
  text("Restart",   24, 312);
  text("1-8 Keys:", 12, 348);
  text("Change lasers",   24, 376);
  textFont(f12);
  text("Collect lasers from", 24, 398);
  text("green bomus aseroids", 24, 412);
  popMatrix();
}


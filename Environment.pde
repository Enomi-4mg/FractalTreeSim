// --- 描画パイプラインのモジュール化 ---

void renderBackground() {
  background(210, 40, 10);
  ambientLight(0, 0, 30);
  directionalLight(0, 0, 80, 0.5, 1, -1); // [cite: 9, 51]
}

float camX = 0, camY = 0, camZoom = 0;

void applyCameraTransform() {
  if (isViewerMode) {
    translate(width/2, height/2, camZoom);
    rotateX(camX);
    rotateY(camY);
    translate(0, 200, 0); // [cite: 53]
  } else {
    translate(width/2, height * 0.9, -200);
    rotateY(frameCount * 0.005); // [cite: 11, 54]
  }
}

void renderGround() {
  pushMatrix();
  rotateX(HALF_PI);
  fill(140, 20, 20);
  noStroke();
  rect(0, 0, 2000, 2000); // [cite: 12, 59]
  
  stroke(140, 20, 30);
  for (int i = -1000; i <= 1000; i += 100) {
    line(i, -1000, i, 1000);
    line(-1000, i, 1000, i); // [cite: 13, 60]
  }
  popMatrix();
}

void drawHUD() {
  hint(DISABLE_DEPTH_TEST);
  fill(255);
  textSize(16);
  text("SIMULATION DAY: " + currentDay + " / " + MAX_DAYS, 30, 40);
  text("CONTROLS: [1] WATER [2] FERTILIZER [3] KOTODAMA | [V] VIEW MODE", 30, 70);
  hint(ENABLE_DEPTH_TEST); // [cite: 14, 15, 66]
}
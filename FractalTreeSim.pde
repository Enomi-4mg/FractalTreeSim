/**
 * 3D Fractal Tree Growth Simulator v2.5
 * [Refactored for Maintenance]
 */

// --- ① 保守性の高い変数管理 (Config Constants) ---
final int   MAX_DAYS         = 30; // [cite: 48]
final int   LIMIT_DEPTH      = 7;  // [cite: 2, 48]
final float INTERPOLATION    = 0.05f; // [cite: 2]
final float ZOOM_SENSITIVITY = 20.0f; // [cite: 3, 64]

// --- システム変数 (Global Variables) ---
Tree    myTree;
int     currentDay = 1;
boolean isViewerMode = false; // [cite: 49]

void setup() {
  size(1000, 800, P3D); // [cite: 6, 50]
  colorMode(HSB, 360, 100, 100); // [cite: 6, 50]
  surface.setTitle("3D Fractal Tree v2.5");
  
  myTree = new Tree(); // [cite: 7, 50]
}

void draw() {
  renderBackground(); // [cite: 8]
  
  pushMatrix();
  applyCameraTransform(); // [cite: 9, 10, 52]
  
  renderGround();    // [cite: 12, 58]
  myTree.update();   // [cite: 31, 80]
  myTree.display();  // [cite: 33, 83]
  popMatrix();
  
  if (!isViewerMode) {
    drawHUD(); // [cite: 14, 56, 66]
  }
}
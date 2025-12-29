/**
 * 3D Fractal Tree Growth Simulator v3.0 (Refactored)
 */

// --- システム設定定数 ---
final int   MAX_DAYS         = 30;
final int   LIMIT_DEPTH      = 7; 
final float INTERPOLATION    = 0.05f;
final float ZOOM_SENSITIVITY = 20.0f;

// --- コマンド種別 ---
final String CMD_WATER      = "WATER";
final String CMD_FERTILIZER = "FERTILIZER";
final String CMD_KOTODAMA   = "KOTODAMA";

Tree    myTree;
int     currentDay = 1;
boolean isViewerMode = false;

void setup() {
  size(1000, 800, P3D);
  colorMode(HSB, 360, 100, 100);
  surface.setTitle("3D Fractal Tree Simulation");
  surface.setLocation(5,5);
  
  myTree = new Tree();
}

void draw() {
  renderBackground();
  
  pushMatrix();
  applyCameraTransform();
  renderGround();   
  
  myTree.update();  
  myTree.display(); 
  popMatrix();
  
  if (!isViewerMode) drawHUD();
}
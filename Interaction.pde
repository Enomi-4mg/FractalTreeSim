void keyPressed() {
  if (key == 'v' || key == 'V') {
    isViewerMode = !isViewerMode; // [cite: 19, 61]
    return;
  }

  if (currentDay >= MAX_DAYS) return;

  if (key == '1') {
    myTree.grow("WATER");
    currentDay++;
  } else if (key == '2') {
    myTree.grow("FERTILIZER");
    currentDay++;
  } else if (key == '3') {
    myTree.grow("KOTODAMA");
    currentDay++;
  } // [cite: 20, 21, 62]
}

void mouseDragged() {
  if (isViewerMode) {
    camY += (mouseX - pmouseX) * 0.01;
    camX -= (mouseY - pmouseY) * 0.01; // [cite: 17, 57]
  }
}

void mouseWheel(MouseEvent event) {
  if (isViewerMode) {
    camZoom -= event.getCount() * ZOOM_SENSITIVITY;
    camZoom = constrain(camZoom, -1200, 600); // [cite: 18, 65]
  }
}
void keyPressed() {
    if (key == 'v' || key == 'V') {
        isViewerMode = !isViewerMode;
        return;
    }
    
    if (currentDay >= MAX_DAYS) return;
    
    // 現在の天候を保持
    WeatherState ws = myWeather.currentState;
    
    boolean acted = false;
    if (key == '1') {
        myTree.grow(CMD_WATER, ws);
        acted = true;
    } else if (key == '2') {
        myTree.grow(CMD_FERTILIZER, ws);
        acted = true;
    } else if (key == '3') {
        myTree.grow(CMD_KOTODAMA, ws);
        acted = true;
    }
    
    if (acted) {
        currentDay++;
        myWeather.setRandom();
    }
}

void mouseDragged() {
    if (isViewerMode) {
        camY += (mouseX - pmouseX) * 0.01;
        camX -= (mouseY - pmouseY) * 0.01;
    }
}

void mouseWheel(MouseEvent event) {
    if (isViewerMode) {
        camZoom -= event.getCount() * ZOOM_SENSITIVITY;
        camZoom = constrain(camZoom, -3000, 600);
    }
}
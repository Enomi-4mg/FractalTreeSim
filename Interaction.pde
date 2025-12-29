void keyPressed() {
    //--- 天候切り替え ---
    if (key == 'w' || key == 'W') {
        myWeather.next();
        return;
    }
    
    if (key == 'v' || key == 'V') {
        isViewerMode = !isViewerMode;
        return;
    }
    
    if (key == 'v' || key == 'V') {
        isViewerMode = !isViewerMode;
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
        camZoom = constrain(camZoom, -1200, 600);
        }
    }
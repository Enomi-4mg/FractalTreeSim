enum State { SUNNY, RAINY, MOONLIGHT }

class Weather {
    State currentState = State.SUNNY;
    
    // 雨のパーティクル用
    int rainCount = 150;
    float[] rainX = new float[rainCount];
    float[] rainY = new float[rainCount];
    
    Weather() {
        for (int i = 0; i < rainCount; i++) {
            rainX[i] = random( -width, width);
            rainY[i] = random( -1000, 0);
        }
    }
    
    void next() {
        int nextIndex = (currentState.ordinal() + 1) % State.values().length;
        currentState = State.values()[nextIndex];
    }
    
    void apply() {
        switch(currentState) {
            case SUNNY:
                background(200, 20, 90); // 明るい空
                ambientLight(0, 0, 50);
                directionalLight(0, 0, 100, 0.5, 1, -1);
                break;
            
            case RAINY:
                background(200, 10, 30); // どんよりした空
                ambientLight(0, 0, 20);
                drawRain();
                break;
            
            case MOONLIGHT:
                background(240, 80, 10); // 深い夜空
                ambientLight(240, 50, 15);
                directionalLight(240, 60, 50, -0.5, 1, -0.5); 
                break;
            }
        }
    
    private void drawRain() {
        stroke(200, 10, 80, 150);
        strokeWeight(1);
        for (int i = 0; i < rainCount; i++) {
            line(rainX[i], rainY[i], rainX[i], rainY[i] + 20);
            rainY[i] += 15;
            if (rainY[i] > 500) rainY[i] = -500;
            }
        }
    }
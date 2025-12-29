class Ground {
    float size = 2000;
    int res = 10; // 分割数（将来的な波形・変形用）
    color gColor;
    
    Ground() {
        // 初期色は緑（HSB: Hue=120付近）
        gColor = color(120, 60, 40); 
}
    
    void display(float mutation) {
        pushMatrix();
        rotateX(HALF_PI);
        
        // カオス度（mutation）に応じて色を濁らせるなどの拡張が可能
        fill(gColor);
        noStroke();
        
        // 平面の描画
        rectMode(CENTER);
        rect(0, 0, size, size);
        
        // グリッド線の描画（デバッグ・目安用）
        stroke(120, 40, 20, 50);
        float step = size / res;
        for (int i = 0; i <= res; i++) {
            float pos = -size / 2 + i * step;
            line(pos, -size / 2, pos, size / 2);
            line( - size / 2, pos, size / 2, pos);
        }
        popMatrix();
}
}
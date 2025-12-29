/**
 * Treeクラス：形状と成長ロジックの管理
 */
class Tree {
  // 現在の動的パラメータ
  float bLen = 100, bThick = 20, bAngle = PI/12; // 初期角度を少し狭く設定
  float bHue = 140, lSize = 10, lHue = 120;
  int   currentDepth = 2;

 // --- カオス・開花パラメータ ---
  float bMutation = 0, tMutation = 0;
  float mutationCurve = 1.5; // 変化率の制御（1.0で線形、1.0より大きいと後半急激に、小さいと前半急激に）
  
  boolean isBloomed = false;
  float bloomFactor = 0;
  final float BLOOM_THRESHOLD = 150.0;
  final int STAGE_3_START = 21;
  
  // 目標値 (lerpターゲット)
  float tLen, tThick, tAngle, tHue, tLSize;

  PShape leafModel;
  PShape flowerModel;

  Tree() {
    initTargets();
    createLeafModel();
    createFlowerModel();
  }

  private void initTargets() {
    tLen = bLen; 
    tThick = bThick;
    tAngle = bAngle;
    tHue = bHue; 
    tLSize = lSize;
  }

  // 成長コマンド
  void grow(String type) {
    float boost = map(currentDay, 1, MAX_DAYS, 1.0, 2.5);
    
    if (type.equals("WATER")) {
      tLen += 15 * boost;
      tThick *= 0.98;
      tLSize += 3 * boost;
      tAngle += 0.02 * boost;
      bloomFactor += 5 * boost;
      tMutation = max(0, tMutation - 0.08);
    } else if (type.equals("FERTILIZER")) {
      tThick += 8 * boost;
      if (currentDepth < LIMIT_DEPTH) currentDepth++;
      bloomFactor += 20 * boost;
      tMutation = max(0, tMutation - 0.06);
    } else if (type.equals("KOTODAMA")) {
      tHue = (tHue + 60) % 360;
      bloomFactor -= 15 * boost;
      tMutation += 0.2 * boost;
    }

    tAngle = constrain(tAngle, 0, PI/4);

    checkBloomCondition();
  }

  void update() {
    bLen   = lerp(bLen, tLen, INTERPOLATION);
    bThick = lerp(bThick, tThick, INTERPOLATION);
    bAngle = lerp(bAngle, tAngle, INTERPOLATION);
    bHue   = lerp(bHue, tHue, INTERPOLATION);
    lSize  = lerp(lSize, tLSize, INTERPOLATION);
    bMutation = lerp(bMutation, tMutation, INTERPOLATION);
  }

  void display() {
    recursiveDraw(bLen, bThick, currentDepth);
  }

  private void recursiveDraw(float len, float thick, int depth) {
    if (depth <= 0) return;

    noStroke();
    fill(bHue, 50, 20 + (currentDepth - depth) * 15);
    drawStem(thick, thick * 0.7, len, depth);
    if (depth <= 2) {
      if (isBloomed) {
        drawFlowers(len, thick, depth);
      } else {
        drawLeaves(len, thick, depth);
      }
    }

    translate(0, -len, 0);

    int branches = (depth <= 3) ? 2 : 3;
    for (int i = 0; i < branches; i++) {
      pushMatrix();
      rotateY((branches == 2) ? (PI * i) : (TWO_PI / 3 * i));
      
      // 風の揺らぎ
      float wind = map(noise(frameCount * 0.01, depth), 0, 1, -0.05, 0.05);
      
      // bAngle（開き具合）を適用
      rotateZ(bAngle + wind);

      recursiveDraw(len * 0.8, thick * 0.65, depth - 1);
      popMatrix();
    }
  }

  private void drawStem(float r1, float r2, float h, int depth) {
    int s = 5; 
    
    // カオス度に基づく変化率の計算
    float m = constrain(bMutation, 0, 1.0);
    float ratio = pow(m, mutationCurve);

    beginShape(QUAD_STRIP);
    for (int i = 0; i <= s; i++) {
      float a = i * TWO_PI / s;
      
      // --- 1. ベースとなる「茶色」の設定 ---
      float baseH = 25;  // 落ち着いた茶色の色相
      float baseS = 40;  // 低めの彩度
      float baseB = 40 + (currentDepth - depth) * 10; // 深さに応じた明度調整

      // --- 2. 「カオス状態」の計算 (前回のロジック) ---
      // 枝の表面を移動する色相オフセット
      float hueOffset = sin(frameCount * 0.05 + depth * 0.5) * 60;
      // 縞模様の干渉
      float stripe = sin(i * 1.5 + frameCount * 0.1) * 30;
      
      float chaosH = (bHue + hueOffset + stripe) % 360;
      float chaosS = 90; // 高い彩度
      float chaosB = 30 + (currentDepth - depth) * 15 + (bMutation * 40);

      // --- 3. 比率(ratio)に応じて色を混ぜる ---
      float finalH = lerp(baseH, chaosH, ratio);
      float finalS = lerp(baseS, chaosS, ratio);
      float finalB = lerp(baseB, chaosB, ratio);

      fill(finalH, finalS, finalB);
      vertex(cos(a) * r1, 0, sin(a) * r1);
      
      // 先端側の頂点（少しだけ色をずらすことで複雑さを出す）
      fill((finalH + 10 * ratio) % 360, finalS, finalB);
      vertex(cos(a) * r2, -h, sin(a) * r2);
    }
    endShape();
  }

  private void drawLeaves(float len, float thick, int depth) {
    // 変化率を適用した比率を算出 (0.0 - 1.0)
    float m = constrain(bMutation, 0, 1.0);
    float ratio = pow(m, mutationCurve);

    // Hue: 120 (緑) -> 320 (赤紫)
    float leafH = map(ratio, 0, 1, 120, 320);
    // Saturation: カオス度に合わせて少し鮮やかに
    float leafS = map(ratio, 0, 1, 70, 90);

    for (int i = 0; i < 2; i++) {
      pushMatrix();
      rotateY(PI * i);
      translate(thick * 0.5, -len * (0.5 + i * 0.3), 0);
      rotateZ(sin(frameCount * 0.06 + depth) * 0.1);
      scale(lSize);
      fill(leafH, leafS, 80, 200);
      shape(leafModel);
      popMatrix();
    }
  }

  private void createLeafModel() {
    leafModel = createShape();
    leafModel.beginShape();
    leafModel.noStroke();
    leafModel.vertex(-1, 0, 0);
    leafModel.vertex(0, -1.5, 0.2);
    leafModel.vertex(1, 0, 0);
    leafModel.vertex(0, 0.5, -0.2);
    leafModel.endShape(CLOSE);

    leafModel.disableStyle();
  }

  private void checkBloomCondition() {
    // 21日目であり、かつまだ判定されていない場合のみ実行
    if (currentDay == STAGE_3_START && !isBloomed) {
      if (bloomFactor >= BLOOM_THRESHOLD) {
        isBloomed = true; // 開花！以降、bloomFactorが下がっても維持される
      }
    }
  }
  
  // 花を描画するメソッド
  private void drawFlowers(float len, float thick, int depth) {
    float m = constrain(bMutation, 0, 1.0);
    float ratio = pow(m, mutationCurve);

    // Hue: 60 (黄) -> 280 (紫)
    float flowerH = map(ratio, 0, 1, 60, 280);
    // Brightness: 100 (明) -> 20 (暗/黒)
    float flowerB = map(ratio, 0, 1, 100, 20);
    // Saturation: 黒紫に近づくほど濃く
    float flowerS = map(ratio, 0, 1, 80, 100);
    for (int i = 0; i < 2; i++) {
      pushMatrix();
      rotateY(PI * i);
      translate(thick * 0.6, -len * 0.8, 0); // 枝の先端寄りに配置
      scale(lSize * 1.5); // 葉より少し大きく
      fill(flowerH, flowerS, flowerB, 220); // 補色に近い色で花を表現
      shape(flowerModel);
      popMatrix();
    }
  }

  // 花弁モデルの生成（単純な4枚花弁）
  private void createFlowerModel() {
    flowerModel = createShape(GROUP);
    for (int i = 0; i < 4; i++) {
      PShape petal = createShape();
      petal.beginShape();
      petal.noStroke();
      petal.vertex(0, 0, 0);
      petal.vertex(0.5, -0.8, 0.1);
      petal.vertex(0, -1.2, 0);
      petal.vertex(-0.5, -0.8, -0.1);
      petal.endShape(CLOSE);

      petal.disableStyle();
      petal.rotateY(HALF_PI * i);
      flowerModel.addChild(petal);
    }
    flowerModel.disableStyle();
  }
}
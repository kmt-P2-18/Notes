// nekomaru

class Menu {
  String [] lines;
  String [] score;
  PImage [] jacket = new PImage [9];
  float center;  // 全体から見た理想の画面の中心の絶対座標
  float current; // 全体から見た現在の画面の中心の絶対座標
  float sizeX=300; // x軸に対するrectの幅
  float marginX=50;// x軸に対するrect間の幅
  boolean playGame=false;
  boolean enter=false;
  HashMap<String, Integer> music_score = new HashMap<String, Integer>();
  HashMap<String, String> song_name = new HashMap<String, String>();

  Menu() {
    lines =loadStrings("songs_list.txt");
    for (int i=0; i<lines.length; i++) {
      jacket[i]=loadImage(lines[i]+"/jacket.png");
      score=loadStrings(lines[i]+"/score.txt");
      music_score.put(lines[i], int(score[0]));
    }
    song_name.put("rinhana", "凛として咲く花の如く");
    song_name.put("noimage", "UNLOCK");
    center = 1600;
    current = 1600;
  }

  void draw() {
    imageMode(CORNER);
    current = approach(center, current);
    float def = current%350;
    float origin = 600 - current;
    background(0);
    cursolDisplay(295, 450, (int)((center-sizeX/2)/350)%jacket.length);
    float iPosX = origin+(sizeX+marginX)*(int((center-150)/350)%jacket.length);
    int n=int(center-150)/350;
    if (center<0) {
      current+=3150;
      center+=3150;
    }
    if (center>3000) {
      current-=3150;
      center-=3150;
    }
    image(jacket[((n+jacket.length-2)%jacket.length)], iPosX-725, 125, 250, 250);
    image(jacket[((n+jacket.length-1)%jacket.length)], iPosX-375, 125, 250, 250);
    image(jacket[(n%jacket.length)], iPosX-25, 125, 250, 250);
    image(jacket[((n+1)%jacket.length)], iPosX+325, 125, 250, 250);
    image(jacket[((n+2)%jacket.length)], iPosX+675, 125, 250, 250);
    noFill();
    strokeWeight(2);
    //左右
    stroke(50);
    rect(150-def, 100, -300, 300);
    rect(500-def, 100, -300, 300);
    rect(1200-def, 100, -300, 300);
    rect(1550-def, 100, -300, 300);
    //中心
    stroke(255);
    rect(850-def, 100, -300, 300);//まんなか
    rect(840-def, 110, -280, 280);//まんなか

    textSize(20);
    text("Best Score", 730+40, 450+20);

    text("<< ", 16, 65);
    text(">> ", 955, 65);
    textSize(35);
    fill(50, 255, 50);
    text("▲ ", 46, 70);
    fill(255, 50, 100);
    text("● ", 920, 70);
    fill(255, 255, 50);
    text("■", 470, 70);
    fill(50, 150, 255);
    text("×", 500, 70);
    fill(0, 100);
    text("▲ ", 46, 70);
    text("● ", 920, 70);
    text("■", 470, 70);
    text("×", 500, 70);

    fill(255);
    textSize(35);
    text(nf(music_score.get(lines[(n%jacket.length)]), 7), 770+40, 490+20);//ファイルから読み込む
    strokeWeight(1);
    line(727+40, 453+20, 830+40, 453+20);
    line(755+40, 492+20, 893+40, 492+20);
    text(song_name.get(lines[(n%jacket.length)]), 35, 518); 
    if (enter&&!lines[(n%jacket.length)].equals("noimage")) { 
      fill(0, 200);
      rect(840-def, 110, -280, 280);//まんなか
      image(start, 593-def, 286);
      playGame=true;
    }
  }


  float approach(float _center, float _current) {
    float def = _center - _current;
    return _current + def * 0.08;
  }

  void buttonPressed() {
    for (i = 0; i < 4; i++) {
      if (long_count[i] == 0) continue;
      if (i == 1 || i == 2) {
        if (!lines[(int(center-150)/350%jacket.length)].equals("noimage")) {
          enter=true;
          menu_enter.rewind();
          menu_enter.play();
        } else enter=false;
        return;
      }
      if (long_count[i] == 1) {
        switch(i) {
        case 0:
          center += 350;
          playGame=false;
          enter=false;
          menu_select.rewind();
          menu_select.play();
          break;
        case 3:
          center -= 350;
          playGame=false;
          enter=false;
          menu_select.rewind();
          menu_select.play();
          break;
        }
      } else if (long_count[i] / 5 > 4) {
        switch(i) {
        case 0:
          center += 350;
          playGame=false;
          enter=false;
          long_count[0] = 20;
          menu_select.rewind();
          menu_select.play();
          break;
        case 3:
          center -= 350;
          playGame=false;
          enter=false;
          long_count[3] = 20;
          menu_select.rewind();
          menu_select.play();
          break;
        }
      }
    }
  }

  void keyPressed() {
    switch(keyCode) {
    case LEFT:
      center -= 350;
      playGame=false;
      enter=false;
      break;
    case RIGHT:
      center += 350;
      playGame=false;
      enter=false;
      break;
    case ENTER:
      if (!lines[(int(center-150)/350%jacket.length)].equals("noimage")) {
        enter=true;
      } else enter=false;
      break;
    default:   
      playGame=false;
      enter=false;
    }
  }

  String selectSong() {
    return lines[(int(center-150)/350%jacket.length)];
  }

  void cursolDisplay(float posX, float posY, int point) {
    pushMatrix();
    translate(posX, posY);
    noFill();
    stroke(255);
    strokeWeight(1.5);
    for (int i=0; i<3; i++) {
      dia(0+200*i);
    }
    noStroke();
    fill(255);
    if (point<3)  dia(0);
    else if (point<6)  dia(200);
    else dia(400);
    popMatrix();
  }

  void dia(float posX) {
    beginShape();
    vertex(posX, 110);
    vertex(posX+10, 100);
    vertex(posX+20, 110);
    vertex(posX+10, 120);
    endShape(CLOSE);
  }
}
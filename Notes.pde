// Notes.pde
// メインプログラム
// 1-4-54 Shunsuke Mano

/*
settings(),setup(), draw(), serialEvent(Serial),  movieEvent(Movie), keyPressed()等の関数が定義されています。
 */

void settings() {
  size(1000, 600);

  // 画像の読み込み
  appear = loadImage("material/appear.png");
  bable  = loadImage("material/bable.png");
  back   = loadImage("material/back.png");
  circle = loadImage("material/circle.png");
  tweet  = loadImage("material/tweet.png");
  start  = loadImage("material/start.png");
  for (i = 0; i < 4; i++) {
    male       [i] = loadImage("note/" +   "male"      + i + ".png");
    female     [i] = loadImage("note/" + "female"      + i + ".png");
    male_long  [i] = loadImage("note/" +   "male_long" + i + ".png");
    female_long[i] = loadImage("note/" + "female_long" + i + ".png");
  }

  // 効果音の読み込み
  minim        = new Minim(this);
  menu_enter   = minim.loadFile("sound/menu_enter.wav");
  menu_select  = minim.loadFile("sound/menu_select.wav");
  result_start = minim.loadFile("sound/result_start.wav");
  result_score = minim.loadFile("sound/result_score.wav");
  for (i = 0; i < 4; i++) {
    play_tap[i] = minim.loadFile("sound/play_tap.wav");
  }

  // その他インスタンス作成、データファイルの読み込み
  desktop = Desktop.getDesktop();
  button  = new Button();
  menu    = new Menu();
  for (String line : loadStrings("music_title.txt")) {
    String[] dictionary = line.split(",");
    music_title.put(dictionary[0], dictionary[1]);
  }
}

void setup() {
  frameRate(-1);
  textFont(createFont("MS Gothic", 20, true));
  imageMode(CENTER);
  strokeCap(SQUARE);

  // arduinoとの接続
  for (i = 0; i < 10; i++) {
    try {
      serial = new Serial( this, Serial.list()[2], 9600 );
      break;
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
}

void draw() {
  switch(mode) {
  case 0:
    if (menu.playGame) {
      music = new Music(menu.selectSong());
      imageMode(CENTER);
      strokeCap(SQUARE);
      menu.enter    = false;
      menu.playGame = false;
      mode = 1;
      iStartMillisecond = millis();
    }
    break;
  case 1:
    if (music.finished) {
      mode = 2;
      music.finished = false;
      imageMode(CORNER);
      int[] countedScore = {0, 0, 0};
      for (i = 0; i < music.results.size(); i++) countedScore[music.results.get(i)]++;
      result = new Result(music.dir, music.max_combo, countedScore);
      menu.playGame = false;
      iStartMillisecond = millis();
    }
    break;
  case 2:
    if (result.finished) {
      mode = 0;
      menu = new Menu();
    }
    break;
  }

  button.phex=button.hex;
  button.hex = _hex;
  buttonPressed = button.buttonPressed();

  switch(mode) {
  case 0:
    for (i = 0; i < 4; i++) buttonPressed[i] = (buttonPressed[i] == 2 ? buttonPressed[i]+1 : 0);
    menu.buttonPressed();
    menu.draw();
    break;
  case 1:
    music.judge(buttonPressed, int((millis()-iStartMillisecond)*0.02));
    music.draw(int((millis()-iStartMillisecond)*0.02));
    break;
  case 2:
    result.buttonPressed(int((millis()-iStartMillisecond)*0.02));
    result.display(int((millis()-iStartMillisecond)*0.02));
    break;
  }
}

void serialEvent(Serial port) {
  button.phex = button.hex;
  button.hex  = port.read();
  buttonPressed = button.buttonPressed();
  switch(mode) {
  case 0:
    menu.buttonPressed();
    break;
  case 1:
    music.judge(buttonPressed, int((millis()-iStartMillisecond)*0.02));
    break;
  case 2:
    result.buttonPressed(int((millis()-iStartMillisecond)*0.02));
    break;
  }
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed() {
  _hex = 0;
  if (key == 'V' || key == 'v') _hex += 8;
  if (key == 'B' || key == 'b') _hex += 4;
  if (key == 'N' || key == 'n') _hex += 2;
  if (key == 'M' || key == 'm') _hex += 1;
  if (mode == 0) menu.keyPressed();
}

void keyReleased() {
  if (key == 'V' || key == 'v') _hex -= 8;
  if (key == 'B' || key == 'b') _hex -= 4;
  if (key == 'N' || key == 'n') _hex -= 2;
  if (key == 'M' || key == 'm') _hex -= 1;
}
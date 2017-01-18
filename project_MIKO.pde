// project_MIKO.pde
// setup(), draw(), serialEvent(Serial),  movieEvent(Movie), keyPressed()等の関数の定義
// 1-4-54 Shunsuke Mano

/*
 注意：現時点では、mac book pro, Processing 3.2.3以外での動作確認が取れていません。
 　　　起動する際はmac OSのProcessing 3.2.3で起動して下さい。
 　　　それでも起動ができない際は、18班のメンバーに連絡をいただけると幸いです。
 */

void setup() {
  size(1000, 600);
  frameRate(-1);
  
  // フォントの読み込み
  textFont(createFont("MS Gothic", 20, true));
  
  // 画像の読み込み
  appear = loadImage("material/appear.png");
  bable  = loadImage("material/bable.png");
  back   = loadImage("material/back.png");
  circle = loadImage("material/circle.png");
  tweet  = loadImage("material/tweet.png");
  start  = loadImage("material/start.png");
  for (i = 0; i < 4; i++) {
    male       [i] = loadImage("material/" +   "male"      + i + ".png");
    female     [i] = loadImage("material/" + "female"      + i + ".png");
    male_long  [i] = loadImage("material/" +   "male_long" + i + ".png");
    female_long[i] = loadImage("material/" + "female_long" + i + ".png");
  }

  // 効果音の読み込み
  minim        = new Minim(this);
  menu_enter   = minim.loadFile("sound/menu_enter.wav");
  menu_select  = minim.loadFile("sound/menu_select.wav");
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
      mode              = 1;
      music             = new Music(menu.selectSong());
      menu.enter        = false;
      menu.playGame     = false;
      iStartMillisecond = millis();
    }
    break;
  case 1:
    if (music.finished) {
      mode               = 2;
      music.finished     = false;
      int[] countedScore = {0, 0, 0};
      for (i = 0; i < music.results.size(); i++) countedScore[music.results.get(i)]++;
      result             = new Result(music.dir, music.max_combo, countedScore);
      menu.playGame      = false;
      iStartMillisecond  = millis();
    }
    break;
  case 2:
    if (result.finished) {
      mode = 0;
      menu = new Menu();
    }
    break;
  }

  currentTime   = int((millis()-iStartMillisecond)*0.02);
  button.phex   = button.hex;
  button.hex    = _hex;
  buttonPressed = button.buttonPressed();

  switch(mode) {
  case 0:
    for (i = 0; i < 4; i++) long_count[i] = (buttonPressed[i] == 2 ? long_count[i]+1 : 0);
    menu.buttonPressed();
    menu.draw();
    break;
  case 1:
    music.judge(buttonPressed, currentTime);
    music.draw(currentTime);
    break;
  case 2:
    result.buttonPressed(currentTime);
    result.display(currentTime);
    break;
  }
}

void serialEvent(Serial port) {
  currentTime   = int((millis()-iStartMillisecond)*0.02);
  button.phex   = button.hex;
  button.hex    = port.read();
  buttonPressed = button.buttonPressed();

  switch(mode) {
  case 0:
    menu.buttonPressed();
    break;
  case 1:
    music.judge(buttonPressed, currentTime);
    break;
  case 2:
    result.buttonPressed(currentTime);
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
  if (mode == 0)                menu.keyPressed();
}

void keyReleased() {
  if (key == 'V' || key == 'v') _hex -= 8;
  if (key == 'B' || key == 'b') _hex -= 4;
  if (key == 'N' || key == 'n') _hex -= 2;
  if (key == 'M' || key == 'm') _hex -= 1;
}
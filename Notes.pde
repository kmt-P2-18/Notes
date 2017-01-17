// fms_eraser

void settings() {
  size(1000, 600);
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

  minim        = new Minim(this);
  menu_enter   = minim.loadFile("sound/menu_enter.wav");
  menu_select  = minim.loadFile("sound/menu_select.wav");
  result_start = minim.loadFile("sound/result_start.wav");
  result_score = minim.loadFile("sound/result_score.wav");
  for (i = 0; i < 4; i++) {
    play_tap[i] = minim.loadFile("sound/play_tap.wav");
  }

  button = new Button();
  menu   = new Menu();
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
  loadSerial();
  iStartMillisecond = millis();
}

void draw() {
  if (mode == 0 && menu.playGame) {
    music = new Music(menu.selectSong());
    imageMode(CENTER);
    strokeCap(SQUARE);
    menu.enter    = false;
    menu.playGame = false;
    mode = 1;
    iStartMillisecond = millis();
  } else if (mode == 1) {
    if (music.finished) {
      mode = 2;
      music.finished = false;
      imageMode(CORNER);
      result = new Result(music.dir, music.max_combo, countScore(music.results));
      menu.playGame = false;
      iStartMillisecond = millis();
    }
  } else if (mode == 2) {
    if (result.finished) {
      mode = 0;
      menu = new Menu();
    }
  }

  if (mode == 0) {
    imageMode(CORNER);
    menu.draw();
  } else if (mode == 1) {
    music.draw(int((millis()-iStartMillisecond)*0.02));
  } else if (mode == 2) {
    result.display(int((millis()-iStartMillisecond)*0.02));
  }
}

void serialEvent(Serial port) {
  button.phex=button.hex;
  button.hex = port.read();
  _buttonPressed_ = button.buttonPressed();

  switch(mode) {
  case 0:
    for (i = 0; i < 4; i++) {
      switch(_buttonPressed_[i]) {
      case 2:
        long_count[i]++;
        break;
      case 3:
        long_count[i] = 0;
        break;
      }
    }
    menu.buttonPressed();
    break;
  case 1:
    music.judge(_buttonPressed_, int((millis()-iStartMillisecond)*0.02));
    break;
  case 2:
    result.buttonPressed();
    break;
  }
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed() {
  if (mode == 0) menu.keyPressed();
  if (mode == 2) result.tweet();
}
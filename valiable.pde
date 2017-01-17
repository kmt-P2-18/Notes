// valiable.pde
// 1-4-54 Shunsuke Mano

/*
 別のプログラム内で使用する変数や定数を定義しています
 */

// 画像
PImage appear, bable, back, circle, tweet, start;
PImage []   male      = new PImage[4];
PImage [] female      = new PImage[4];
PImage []   male_long = new PImage[4];
PImage [] female_long = new PImage[4];

// 効果音
Minim       minim;
AudioPlayer menu_enter, menu_select;
AudioPlayer [] play_tap = new AudioPlayer [4];

// ディレクトリ名と曲名のHashMap
HashMap<String, String> music_title = new HashMap<String, String>();

// その他変数
int iStartMillisecond = 0;
int mode              = 0;
int currentTime       = 0;
int[] long_count      = {0, 0, 0, 0};
int[] buttonPressed   = {0, 0, 0, 0};

// メニュー画面、楽曲プレイ画面、リザルト画面
Menu   menu;
Music  music;
Result result;

// arduino
Serial serial;
Button button;

// Result.tweetScoreに使用するDesktopインスタンス
Desktop desktop;

// 定数
final float NOTE_SIZE      = 40;
final float HALF_SIZE      = 20;
final float SMALL_SIZE     = 1.4142135;
final String[] JUDGE_RANK  = {"BAD", "GOOD", "COOL"};
final color [] LONG_COLOR  = {color(255, 75, 150), color(75, 150, 255), color(255, 255, 75), color(75, 255, 75)};
final color [] JUDGE_COLOR = {color(100, 100, 190), color(100, 240, 100), color(240, 190, 10)};

// 動画を読み込む関数
Movie loadMovie(String fileName) {
  return new Movie(this, fileName);
}

// 処理を軽くするため、関数内で使用する一時変数を先に確保しています(両端を_で囲む)
int     i, _past_, _hex, _hex_, _phex_, _h_, _p_, _figure_, _duration_, _timeDet_;
int     _buttonPressed_[] = new int [4];
float   _theta_, _begin_, _middle_, _terminal_, _end_, _theta2_, _resized_;
String  _encodedText_;
PVector _currentPos_, _secondPos_, _vector_;
Route   _route_;
Note    _firstNote_;
Det[]   _dets_;
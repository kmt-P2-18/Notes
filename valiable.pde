// fms_eraser

PImage appear, bable, back, circle, tweet, start;
PImage []   male      = new PImage[4];
PImage [] female      = new PImage[4];
PImage []   male_long = new PImage[4];
PImage [] female_long = new PImage[4];

AudioPlayer menu_enter, menu_select,  result_start, result_score;
AudioPlayer [] play_tap = new AudioPlayer [4];

int iStartMillisecond, mode;
int long_count[] = {0, 0, 0, 0};
Minim  minim;
Music  music;
Serial serial;
Button button;
Menu   menu;
Result result;

final float NOTE_SIZE  = 40;
final float HALF_SIZE  = 20;
final float SMALL_SIZE = 1.4142135;
final String[] JUDGE_RANK  = {"BAD", "GOOD", "COOL"};
final color [] LONG_COLOR  = {color(255, 75, 150), color(75, 150, 255), color(255, 255, 75), color(75, 255, 75)};
final color [] JUDGE_COLOR = {color(100, 100, 190), color(100, 240, 100), color(240, 190, 10)};

HashMap<String, String> music_title = new HashMap<String, String>();

// 処理を軽くするため、関数内で使用する一時変数を先に確保しておく(両端を_で囲む)

// 全共通
int i, _past_;

//Button.pde
int _hex_, _phex_, _h_, _p_;
int []_buttonPressed_ = new int [4];

// Group.pde, Det.pde
int _figure_, _duration_;
float _theta_;
Route _route_;
Note _firstNote_;
Det[] _dets_;

// Music.pde

// Note.pde
PVector _currentPos_, _secondPos_;
int _timeDet_;

// Route.pde
PVector _vector_;

// method.pde
String _encodedText_;
float _begin_, _middle_, _terminal_, _end_, _theta2_, _resized_;
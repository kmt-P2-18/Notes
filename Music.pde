// Music.pde
// 楽曲データに関するクラス
// 1-4-54 Shunsuke Mano

/*
 譜面や、動画、歌詞などのデータを持つクラスです。
 コンストラクタに楽曲名を渡すと、 data/(楽曲名) 以下に置かれているファイルからインスタンスを作成します。
 */

import processing.video.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

class Music {

  /*
   dir       : 楽曲データが保存されているディレクトリ名
   name      : 楽曲の名前
   groups    : 複数のノーツを保持するGroupのインスタンスの配列
   lyrics    : 表示する歌詞データ
   movie     : 表示する動画データ
   combo_num : プレイ中のコンボ数を管理します。
   max_combo : プレイ中の最大コンボ数を管理します。
   finished  : 楽曲の再生が終了したかを保持します。
   notes     : プレイ中の残りのノーツを保持します。順番は時間によって並べ直されます。
   effects   : プレイ中に発生したエフェクトを保持します。
   results   : ノーツの判定結果を保持します。(0:BAD, 1:GOOD, 2:COOL)
   */

  String  dir;
  String  name;
  Group[] groups;
  Lyrics  lyrics;
  Movie   movie;
  int     combo_num = 0;
  int     max_combo = 0;
  boolean finished  = false;

  ArrayList<Note>   notes   = new ArrayList<Note>();
  ArrayList<Effect> effects = new ArrayList<Effect>();
  IntList           results = new IntList();

  Music(String dirName) {
    this.dir  = dirName;
    this.name = music_title.get(dirName);
    JSONArray _jsonarray = loadJSONObject(dirName + "/notes.json").getJSONArray("Groups");
    groups = new Group [_jsonarray.size()];
    for (int i = 0; i < _jsonarray.size(); i++) {
      groups[i] = new Group(_jsonarray.getJSONObject(i));
    }
    for (Group g : groups) {
      for (Note n : g.notes) notes.add(n);
    }
    lyrics = new Lyrics(dirName + "/lyrics.txt");
    movie  =  loadMovie(dirName + "/movie.mov");
    java.util.Collections.sort(this.notes, new NoteComparator());
    this.movie.loop();
  }

  void draw(int _currentTime) {
    imageMode(CENTER);
    strokeCap(SQUARE);
    background(128);
    tint(255, 255);
    image(movie, width/2, height/2, 1072, 600);
    for (Note   note   : this.notes)   note.draw(_currentTime);
    for (Effect effect : this.effects) effect.draw(_currentTime);
    tint(255, 255);
    image(back, width/2, height/2);
    textSize(18);
    textAlign(LEFT);
    fill(20);
    text(name, 44, 23);
    text(lyrics.word(_currentTime), 152, 563);
    fill(230);
    text(name, 43, 22);
    text(lyrics.word(_currentTime), 151, 562);
    _timeDet_ =  _currentTime - int(this.movie.duration()) * 20;
    if (_timeDet_ < 0) return;
    if (_timeDet_ > 20) this.finished = true;
    movie.stop();
  }

  void judge(int[] judged, int _currentTime) {
    for (int i = 0; i < 4; i++) {
      if (judged[i] == 1) {
        play_tap[i].rewind();
        play_tap[i].play();
      }
    }
    for (i = 0; i < min(2, this.notes.size()); i++) {
      if (_currentTime - notes.get(i).route.timing <= -4) return;
      _timeDet_ = _currentTime - notes.get(i).route.timing - notes.get(i).duration;
      if (_timeDet_ > 3) {
        this.combo_num = 0;
        effects.add(new Effect(notes.get(i).route.pos, 0, 0, _currentTime));
        results.append(0);
        notes.remove(i);
        i--;
        continue;
      }
      int figure  = notes.get(i).figure;
      if (judged[figure] == (notes.get(i).duration == 0 ? 1 : 3)) {
        if (_timeDet_ <= -4) break;
        if (abs(_timeDet_) <= 1) {
          this.combo_num++;
          this.max_combo = max(this.max_combo, this.combo_num);
          effects.add(new Effect(notes.get(i).route.pos, 2, combo_num, _currentTime));
          results.append(2);
          notes.remove(i);
          i--;
          continue;
        } else if (abs(_timeDet_) <= 2) {
          this.combo_num++;
          this.max_combo = max(this.max_combo, this.combo_num);
          effects.add(new Effect(notes.get(i).route.pos, 1, combo_num, _currentTime));
          results.append(1);
          notes.remove(i);
          i--;
          continue;
        } else if (_timeDet_ >= -3) {
          this.combo_num = 0;
          effects.add(new Effect(notes.get(i).route.pos, 0, 0, _currentTime));
          results.append(0);
          notes.remove(i);
          i--;
          continue;
        }
      }
      if (notes.get(i).duration != 0) {
        _timeDet_ = _currentTime - notes.get(i).route.timing;
        if (_timeDet_ > -3) return;
        if (_timeDet_ >= -3 && _timeDet_ <= -2 && judged[figure] != 0) {
          effects.add(new Effect(notes.get(i).route.pos, 0, 0, _currentTime));
          results.append(0);
          notes.remove(i);
          i--;
        } else if (_timeDet_ >= 2 && judged[figure] != 2) {
          effects.add(new Effect(notes.get(i).route.pos, 0, 0, _currentTime));
          results.append(0);
          results.append(0);
          notes.remove(i);
          i--;
        }
      }
    }
  }
}
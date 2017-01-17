// Note.pde
// ノーツに関するクラス、ノーツ同士を比較するためのComperatorクラス
// 1-4-54 Shunsuke Mano

/*
 ノーツの形や、動く軌道などをフィールドに持ちます。
 */

class Note {

  /*
   figure   : ノーツの形(0:◯, 1:X, 2:△, 3:□)
   duration : 長押しノーツの継続時間を指定します。(長押しでなければ0)
   route    : ノーツの動く軌道
   */

  int   figure;
  int   duration = 0;
  Route route;

  Note(int _figure, Route _route) {
    figure   = _figure;
    route    = _route;
  }

  Note(int _figure, Route _route, int _duration) {
    figure   = _figure;
    route    = _route;
    duration = _duration;
  }

  Note(JSONObject _json) { // "Route"オブジェクトを引数に渡す
    figure   = _json.getInt("figure");
    route    = new Route(_json);
    if (!_json.isNull("duration")) duration = _json.getInt("duration");
  }

  void draw(int _currentTime) {
    _currentPos_ = route.currentThroughPos(_currentTime);
    tint(255, 255);
    if (this.duration == 0) {
      if (_currentTime >= this.route.timing-30 && _currentTime <= this.route.timing+1) {
        image(female[figure], route.pos.x, route.pos.y);
        arrow(route.pos, PI * (0.5 - (route.timing - _currentTime)* 4));
        _past_ = 15 + _currentTime - this.route.timing;
        tint(255, 255 - _past_ * 20);
        image(appear, route.pos.x, route.pos.y, NOTE_SIZE*1.5+_past_*5, NOTE_SIZE*1.5+_past_*5);
      } else return;
      tint(255, 255);
      image(male[figure], _currentPos_.x, _currentPos_.y);
    } else {
      if (_currentTime >= this.route.timing-30 && _currentTime <= this.route.timing+this.duration+1) {
        _secondPos_ = this.route.currentPos(_currentTime-this.duration);
        strokeWeight(30);
        stroke(LONG_COLOR[figure], 255);
        noFill();
        vectorArc(this.route.center, _secondPos_, _currentPos_, PVector.sub(this.route.pos, this.route.center).heading(), this.route.direction);
        stroke(-1, -1);
        image(female_long[figure], route.pos.x, route.pos.y);
        tint(255, 255);
        _currentPos_ = route.currentPos(_currentTime);
        image(male_long[figure], _secondPos_.x, _secondPos_.y);
        image(male_long[figure], _currentPos_.x, _currentPos_.y);
        _timeDet_ = _currentTime - this.route.timing - this.duration;
        _past_    = _timeDet_ + 28;
        if (_past_ > 0) {
          tint(255, 255 - _past_ * 20);
          image(appear, route.pos.x, route.pos.y, NOTE_SIZE*1.5+_past_*5, NOTE_SIZE*1.5+_past_*5);
        }
        arrow(route.pos, PI * (0.5 - (min(28.8, -_timeDet_))* 4));
      }
    }
  }

  void arrow(PVector _pos, float _degree) {
    if (_degree >= PI*2) return;
    fill(0);
    pushMatrix();
    translate(_pos.x, _pos.y);
    rotate(radians(_degree));
    stroke(255);
    strokeWeight(2);
    beginShape();
    vertex(     - SMALL_SIZE, - SMALL_SIZE);
    vertex( -0.1 * HALF_SIZE, -  HALF_SIZE);
    vertex(                0, - 1.2 *  HALF_SIZE);
    vertex(       SMALL_SIZE, -  HALF_SIZE);
    vertex(       SMALL_SIZE, - SMALL_SIZE);
    vertex(     - SMALL_SIZE, - SMALL_SIZE);
    vertex(     - SMALL_SIZE, SMALL_SIZE);
    vertex(       SMALL_SIZE, SMALL_SIZE);
    vertex(       SMALL_SIZE, - SMALL_SIZE);
    endShape(CLOSE);
    popMatrix();
  }
}

// クラスの時間によってソートするためのクラス

import java.util.Comparator;

class NoteComparator implements Comparator<Note> {
  public int compare(Note note1, Note note2) {
    return note1.route.timing - note2.route.timing;
  }
}

// 長押しノーツを描画する際に使用した関数

void vectorArc(PVector _center, PVector _pos1, PVector _pos2, float _max_theta, int _direction) {
  _begin_    = radResize(PVector.sub(_pos1, _center).heading());
  _middle_   = radResize(_max_theta);
  _terminal_ = radResize(PVector.sub(_pos2, _center).heading());
  _end_      =  0;
  if (_direction == 1) {
    _theta_  = radResize(  _middle_ - _begin_);
    _theta2_ = radResize(_terminal_ - _begin_);
    if (_theta_ <= _theta2_) _end_ = _middle_;
    else                     _end_ = _terminal_;
  } else {
    _theta_  = radResize(_begin_ -   _middle_);
    _theta2_ = radResize(_begin_ - _terminal_);
    if (_theta2_ <= _theta_) _end_ = _terminal_;
    else _end_ = _middle_;
  }
  limitedArc(_center.x, _center.y, PVector.dist(_center, _pos1)*2, _begin_, _end_, _direction);
}

void limitedArc(float x, float y, float r, float begin, float end, int direction) {
  if (begin == end) return;
  if (direction == 1) {
    if (begin < end) {
      arc(x, y, r, r, begin, end);
    } else {
      arc(x, y, r, r, begin, PI*2);
      arc(x, y, r, r, 0, end);
    }
  } else {
    if (begin > end) {
      arc(x, y, r, r, end, begin);
    } else {
      arc(x, y, r, r, 0, begin);
      arc(x, y, r, r, end, PI*2);
    }
  }
}

// 角度を0〜2πの間に変換します
float radResize(float _rad) {
  _resized_ = _rad;
  for (; _resized_ <=    0; _resized_ += PI*2) {
  }
  for (; _resized_ >= PI*2; _resized_ -= PI*2) {
  }
  return _resized_;
}
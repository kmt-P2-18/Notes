// fms_eraser

class Note {

  /*
   figure : ノーツの形(0:◯, 1:X, 2:△, 3:□)
   route  : ノーツの動く軌道
   */

  int   figure;
  int   duration;
  Route route;

  Note(int _figure, Route _route) {
    figure   = _figure;
    route    = _route;
    duration = 0;
  }

  Note(int _figure, Route _route, int _duration) {
    figure   = _figure;
    route    = _route;
    duration = _duration;
  }  

  Note(JSONObject _json) { // "Route"オブジェクトを引数に渡す
    figure   = _json.getInt("figure");
    route    = new Route(_json);
    if (_json.isNull("duration")) {
      duration = 0;
    } else {
      duration = _json.getInt("duration");
    }
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
        arc(this.route.center, _secondPos_, _currentPos_, PVector.sub(this.route.pos, this.route.center).heading(), this.route.direction);
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

import java.util.Comparator;

class NoteComparator implements Comparator<Note> {
  public int compare(Note note1, Note note2) {
    return note1.route.timing - note2.route.timing;
  }
}
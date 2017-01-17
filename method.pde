// fms_eraser

import java.awt.Desktop;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

Desktop desktop = Desktop.getDesktop();

void openTweetScreen(String _text) {
  try {
    _encodedText_ = URLEncoder.encode(_text, "UTF-8");
    URI uri = new URI("https://twitter.com/intent/tweet?text=" + _encodedText_);
    desktop.browse(uri);
  }
  catch(URISyntaxException e) {
    e.printStackTrace();
  }
  catch(IOException e) {
    e.printStackTrace();
  }
}

void arc(PVector _center, PVector _pos1, PVector _pos2, float _max_theta, int _direction) {
  _begin_    = radResize(PVector.sub(_pos1, _center).heading());
  _middle_   = radResize(_max_theta);
  _terminal_ = radResize(PVector.sub(_pos2, _center).heading());
  _end_      =  0;
  if (_direction == 1) {
    _theta_  = radResize(  _middle_ - _begin_);
    _theta2_ = radResize(_terminal_ - _begin_);
    if (_theta_ <= _theta2_) {
      _end_ = _middle_;
    } else {
      _end_ = _terminal_;
    }
  } else {
    _theta_  = radResize(_begin_ -   _middle_);
    _theta2_ = radResize(_begin_ - _terminal_);
    if (_theta2_ <= _theta_) {
      _end_ = _terminal_;
    } else {
      _end_ = _middle_;
    }
  }
  arc(_center.x, _center.y, PVector.dist(_center, _pos1)*2, _begin_, _end_, _direction);
}

int[] countScore(IntList _result) {
  int[] _countScore = {0, 0, 0};
  for (i = 0; i < _result.size(); i++) {
    _countScore[_result.get(i)]++;
  }
  return _countScore;
}

float radResize(float _rad) {
  _resized_ = _rad;
  for (; _resized_ <=    0; _resized_ += PI*2) {
  }
  for (; _resized_ >= PI*2; _resized_ -= PI*2) {
  }
  return _resized_;
}

void arc(float x, float y, float r, float begin, float end, int direction) {
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

void loadSerial() {
  try {
    serial = new Serial( this, Serial.list()[2], 9600 );
  }
  catch(Exception e) {
    loadSerial();
  }
}

Movie loadMovie(String fileName) {
  return new Movie(this, fileName);
}
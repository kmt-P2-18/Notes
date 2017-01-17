// fms_eraser

class Route {

  /*
   center    : ノーツの動く円の中心の座標
   pos       : ノーツが最終的に到達する地点の座標
   speed     : ノーツの動く速度
   timing    : ノーツが押される理想のタイミング
   direction : ノーツの回転方向(-1:反時計回り, 1:時計回り)
   radSpeed  : ノーツの角速度
   */

  PVector center;
  PVector pos;
  float speed;
  int   timing;
  int   direction;
  float radSpeed;
  float radius;

  Route(PVector _center, PVector _pos, float _speed, int _timing, int _direction) {
    center        = _center;
    pos           = _pos;
    speed         = _speed;
    timing        = _timing;
    direction     = _direction;
    radius        = PVector.dist(this.center, this.pos);
    radSpeed      = speed / radius;
  }

  Route(Route _route, Det _det, float theta) {
    center        = _route.center;
    direction     = _route.direction;
    speed         = _route.speed;
    timing        = _route.timing + _det.time;
    pos           = PVector.add(_route.pos, new PVector(_det.distance*cos(theta), _det.distance*sin(theta)));
    radius        = PVector.dist(this.center, this.pos);
    radSpeed      = speed / radius;
  }

  Route(JSONObject _json) {
    center        = new PVector(_json.getJSONObject("center").getInt("x"), _json.getJSONObject("center").getInt("y"));
    pos           = new PVector(_json.getJSONObject("pos").getInt("x"), _json.getJSONObject("pos").getInt("y"));
    speed         = _json.getInt("speed");
    timing        = _json.getInt("time");
    direction     = _json.getInt("direction");
    radius        = PVector.dist(this.center, this.pos);
    radSpeed      = speed / radius;
  }

  PVector currentPos(int _currentTime) {
    if (_currentTime >= timing) return this.pos;
    _vector_ = PVector.sub(this.pos, this.center);
    _theta_  = -1 * this.direction * this.radSpeed * (this.timing - _currentTime);
    // 回転行列を用いた一次変換
    return (_vector_.rotate(_theta_)).add(this.center);
  }

  PVector currentThroughPos(int _currentTime) {
    _vector_ = PVector.sub(this.pos, this.center);
    _theta_  = -1 * this.direction * this.radSpeed * (this.timing - _currentTime);
    // 回転行列を用いた一次変換
    return (_vector_.rotate(_theta_)).add(this.center);
  }

  boolean onDisplay(int _currentTime) {
    _timeDet_ = this.timing - _currentTime;
    if (_timeDet_ < 0) return false;
    _currentPos_ = this.currentPos(_currentTime);
    return _currentPos_.x >= HALF_SIZE && _currentPos_.x <= width-HALF_SIZE && _currentPos_.y >= HALF_SIZE && _currentPos_.y <= height-HALF_SIZE;
  }
}
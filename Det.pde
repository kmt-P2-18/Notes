// fms_eraser

class Det {
  float distance;
  int time;
  int figure;
  int duration;

  Det(float _distance, int _time, int _figure) {
    distance = _distance;
    time     = _time;
    figure   = _figure;
    duration = 0;
  }

  Det(float _distance, int _time, int _figure, int _duration) {
    distance = _distance;
    time     = _time;
    figure   = _figure;
    duration = _duration;
  }

  Det(JSONObject _json) {
    distance = _json.getInt("distance");
    time     = _json.getInt("time");
    figure   = _json.getInt("figure");
    if (_json.isNull("duration")) {
      duration = 0;
    } else {
      duration = _json.getInt("duration");
    }
  }
}

Det[] JSONArray_to_DetArray(JSONArray _jsonarray) {
  _dets_ = new Det [_jsonarray.size()];
  for (i = 0; i < _jsonarray.size(); i++) {
    _dets_[i] = new Det(_jsonarray.getJSONObject(i));
  }
  return _dets_;
}
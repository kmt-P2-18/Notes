// Det.pde
// ノーツの定義に使用するDetという差分に関するクラス
// 1-4-54 Shunsuke Mano

/*
定義したグループ内では、ノーツを１つ前のノーツとの差分で定義しています。(グループ内最初のノーツを除く)
 */

class Det {

  /*
   distance : １つ前のノーツとの距離を定義します。(円の中心側が負)
   time     : １つ前のノーツとの時間の差を定義します。(負の値も指定できる)
   figure   : ノーツの形を指定します。(0:◯, 1:X, 2:△, 3:□)
   duration : 長押しノーツの継続時間を指定します。(長押しでなければ0)
   */

  float distance;
  int time;
  int figure;
  int duration;

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
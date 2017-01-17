// Group.pde
// 複数のノーツを保持するグループに関するクラス
// 1-4-54 Shunsuke Mano

/*
 project DIVAという音楽ゲームのプレイ動画から研究した結果、複数のノーツをまとめるという発想に至りました。
 詳しくは 譜面ファイル(JSON)の書き方.pdf を参照してください。
 */

class Group {

  /*
   notes : 複数のノーツを配列として保持します。
   */

  Note[]  notes;

  Group(JSONObject _json) {
    _route_    = new Route(_json.getJSONObject("Route"));
    _figure_   = _json.getJSONObject("Route").getInt("figure");
    if (_json.getJSONObject("Route").isNull("duration")) _firstNote_ = new Note(_figure_, _route_);
    else _firstNote_ = new Note(_figure_, _route_, _json.getJSONObject("Route").getInt("duration"));
    _theta_ = _json.getJSONObject("Route").getFloat("theta");
    _dets_  = JSONArray_to_DetArray(_json.getJSONArray("Notes"));
    notes = new Note [_dets_.length+1];
    notes[0] = _firstNote_;
    for (i = 1; i < notes.length; i++) {
      notes[i] = new Note(_dets_[i-1].figure, new Route(notes[i-1].route, _dets_[i-1], _theta_), _dets_[i-1].duration);
    }
  }
}
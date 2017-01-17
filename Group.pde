// fms_eraser

class Group {
  Note[]  notes;

  Group(JSONObject _json) {
    _route_    = new Route(_json.getJSONObject("Route"));
    _figure_   = _json.getJSONObject("Route").getInt("figure");
    if (_json.getJSONObject("Route").isNull("duration")) {
      _firstNote_ = new Note(_figure_, _route_);
    } else {
      _firstNote_ = new Note(_figure_, _route_, _json.getJSONObject("Route").getInt("duration"));
    }
    _theta_ = _json.getJSONObject("Route").getFloat("theta");
    _dets_  = JSONArray_to_DetArray(_json.getJSONArray("Notes"));
    notes = new Note [_dets_.length+1];
    notes[0] = _firstNote_;
    for (i = 1; i < notes.length; i++) {
      notes[i] = new Note(_dets_[i-1].figure, new Route(notes[i-1].route, _dets_[i-1], _theta_), _dets_[i-1].duration);
    }
  }
}
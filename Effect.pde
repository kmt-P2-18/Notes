// fms_eraser

class Effect {

  PVector center;
  int     judge;
  int     startTime;
  String  decision;

  Effect(PVector _center, int _judge, int _combo, int _startTime) {
    center    = _center;
    judge     = _judge;
    startTime = _startTime;
    decision  = JUDGE_RANK[_judge];
    if (_combo > 1) {
      decision += " " + _combo;
    }
  }

  void draw(int _currentTime) {
    _past_ = _currentTime - this.startTime;
    if (_past_ > 25) return;
    fill(JUDGE_COLOR[this.judge], 255 - pow(_past_, 3) * 0.25);
    textAlign(CENTER);
    textSize(25);
    text(this.decision, this.center.x, this.center.y - NOTE_SIZE * 0.8);
    if (this.judge == 0) return;
    tint(255, 255 - _past_ * 20);
    image(bable, this.center.x, this.center.y, NOTE_SIZE+_past_*5, NOTE_SIZE+_past_*5);
  }
}
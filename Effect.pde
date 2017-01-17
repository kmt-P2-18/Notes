// Effect.pde
// エフェクトに関するクラス
// 1-4-54  Shunsuke Mano

/*
ノーツが消える時のエフェクトを表示するクラスです。
 判定によってエフェクトが変化します。
 */

class Effect {

  /*
   center    : エフェクトを表示する位置を指定します。
   judge     : 表示するエフェクトの種類を指定します。(0:BAD, 1:GOOD, 2:COOL)
   startTime : エフェクト表示が開始される時間を指定します。
   decision  : judgeとコンボ数を元に評価を保持します。(BAD, GOOD, COOLのどれかとコンボ数)
   */

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
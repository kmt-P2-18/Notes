// ikeda

import processing.serial.*;

class Button {

  int hex=0, phex=0;

  int[] buttonPressed() {

    _h_=hex%2;
    _p_=phex%2;
    if (_h_==1&&_p_==0) _buttonPressed_[0]=1;
    else if (_h_==0&&_p_==1) _buttonPressed_[0]=3;
    else _buttonPressed_[0]=_h_+_p_;

    _hex_=hex/2;
    _phex_=phex/2;
    _p_=_hex_%2;
    _h_=_phex_%2;
    if (_h_==1&&_p_==0) _buttonPressed_[1]=1;
    else if (_h_==0&&_p_==1) _buttonPressed_[1]=3;
    else _buttonPressed_[1]=_h_+_p_;

    _hex_/=2;
    _phex_/=2;
    _p_=_hex_%2;
    _h_=_phex_%2;
    if (_h_==1&&_p_==0) _buttonPressed_[2]=1;
    else if (_h_==0&&_p_==1) _buttonPressed_[2]=3;
    else _buttonPressed_[2]=_h_+_p_;

    _hex_/=2;
    _phex_/=2;
    _p_=_hex_%2;
    _h_=_phex_%2;
    if (_h_==1&&_p_==0) _buttonPressed_[3]=1;
    else if (_h_==0&&_p_==1) _buttonPressed_[3]=3;
    else _buttonPressed_[3]=_h_+_p_;

    return _buttonPressed_;
  }
}
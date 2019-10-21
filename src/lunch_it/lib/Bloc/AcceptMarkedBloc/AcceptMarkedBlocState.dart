

class AcceptMarkedBlocState {
  int _mode=-1;
  AcceptMarkedBlocState._();

  bool isAcceptMarkedFood() => _mode == 0;
  bool isAcceptMarkedPrice() => _mode == 1;

  factory AcceptMarkedBlocState.markedFood() => AcceptMarkedBlocState._().._mode = 0;
  factory AcceptMarkedBlocState.markedPrice() => AcceptMarkedBlocState._().._mode = 1;
}
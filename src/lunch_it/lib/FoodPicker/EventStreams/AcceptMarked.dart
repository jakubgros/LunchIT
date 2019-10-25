import 'dart:async';

class AcceptMarkedEventStream {
  StreamController _controller = StreamController<AcceptMarkedBlocEvent>();
  get stream => _controller.stream;
  get sink => _controller.sink;

  void close() => _controller.close();

}

class AcceptMarkedBlocEvent { //TODO rename and move to diff location and file
  int _type=-1;
  AcceptMarkedBlocEvent._();

  bool isAcceptMarkedFood() => _type == 0;
  bool isAcceptMarkedPrice() => _type == 1;

  factory AcceptMarkedBlocEvent.markedFood() => AcceptMarkedBlocEvent._().._type = 0;
  factory AcceptMarkedBlocEvent.markedPrice() => AcceptMarkedBlocEvent._().._type = 1;
}
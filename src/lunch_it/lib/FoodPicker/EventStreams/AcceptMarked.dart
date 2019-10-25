import 'dart:async';

class AcceptMarkedEventStream {
  StreamController _controller = StreamController<AcceptMarkedEvent>();
  get stream => _controller.stream;
  get sink => _controller.sink;

  void close() => _controller.close();

}

class AcceptMarkedEvent {
  int _type=-1;
  AcceptMarkedEvent._();

  bool isAcceptMarkedFood() => _type == 0;
  bool isAcceptMarkedPrice() => _type == 1;

  factory AcceptMarkedEvent.markedFood() => AcceptMarkedEvent._().._type = 0;
  factory AcceptMarkedEvent.markedPrice() => AcceptMarkedEvent._().._type = 1;
}
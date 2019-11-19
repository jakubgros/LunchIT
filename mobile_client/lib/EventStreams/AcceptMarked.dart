import 'dart:async';

class AcceptMarkedEventStream {
  StreamController _controller = StreamController<AcceptMarkedEvent>();
  get stream => _controller.stream;
  get sink => _controller.sink;

  void close() => _controller.close();
}

class AcceptMarkedEvent {
  _EventType _type;
  AcceptMarkedEvent._();

  bool isAcceptMarkedFood() => _type == _EventType.food;
  bool isAcceptMarkedPrice() => _type == _EventType.price;

  factory AcceptMarkedEvent.markedFood() => AcceptMarkedEvent._().._type = _EventType.food;
  factory AcceptMarkedEvent.markedPrice() => AcceptMarkedEvent._().._type = _EventType.price;
}

enum _EventType {
  food,
  price
}
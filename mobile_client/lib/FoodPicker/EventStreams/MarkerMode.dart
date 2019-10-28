import 'dart:async';

class MarkerModeEventStream { //TODo extract repetition
  StreamController _controller = StreamController<MarkerModeEvent>();
  get stream => _controller.stream;
  get sink => _controller.sink;

  void close() => _controller.close();
}

class MarkerModeEvent {
  _EventType _type;
  MarkerModeEvent._();

  bool isMarkFood() => _type == _EventType.markFood;
  bool isMarkPrice() => _type == _EventType.markPrice;
  bool isNavigate() => _type == _EventType.navigate;

  factory MarkerModeEvent.markFood() => MarkerModeEvent._().._type = _EventType.markFood;
  factory MarkerModeEvent.markPrice() => MarkerModeEvent._().._type = _EventType.markPrice;
  factory MarkerModeEvent.navigate() => MarkerModeEvent._().._type = _EventType.navigate;
}

enum _EventType { //TODO check if is private to the file
  markFood,
  markPrice,
  navigate
}